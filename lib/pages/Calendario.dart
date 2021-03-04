import 'dart:developer';
import 'package:flutter/material.dart';
import "package:googleapis_auth/auth_io.dart";
import 'package:googleapis/calendar/v3.dart';
import 'package:url_launcher/url_launcher.dart';

class Calendario{
  static const _scopes = const [CalendarApi.CalendarScope];

  insert(title, startTime, endTime) {
    var _clientID = new ClientId("771867293863-lafc5dkflulj95fpah11gnk40m93n31l.apps.googleusercontent.com", "");
    clientViaUserConsent(_clientID, _scopes, prompt).then((AuthClient client) {
      var calendar = CalendarApi(client);
      calendar.calendarList.list().then((value) => print("VAL________$value"));

      String calendarId = "primary";
      Event event = Event();

      event.summary = title;

      EventDateTime start = new EventDateTime();
      start.dateTime = startTime;
      start.timeZone = "GMT-03:00";
      event.start = start;

      EventDateTime end = new EventDateTime();
      end.timeZone = "GMT-03:00";
      end.dateTime = endTime;
      event.end = end;
      try {
        calendar.events.insert(event, calendarId).then((value) {
          print("ADDEDDD_________________${value.status}");
          if (value.status == "confirmed") {
            log('Evento adicionado no google calendar');
          } else {
            log("Não foi possível adicionar o evento no google calendar");
          }
        });
      } catch (e) {
        log('Erro criando evento $e');
      }
    });
  }

  void prompt(String url) async {
    print("Please go to the following URL and grant access:");
    print("  => $url");
    print("");

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}