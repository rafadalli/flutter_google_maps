import 'package:agenda_app/pages/Calendario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class PaginaCalendario extends StatefulWidget {
  // var doc;
  @override
  _PaginaCalendarioState createState() => _PaginaCalendarioState();
}

class _PaginaCalendarioState extends State<PaginaCalendario> {
  Calendario calendarClient = Calendario();
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(Duration(days: 1));
  TextEditingController _eventName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2020, 3, 5),
                        maxTime: DateTime(2200, 6, 7), onChanged: (date) {
                          print('change $date');
                        }, onConfirm: (date) {
                          setState(() {
                            this.startTime = date;
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Text(
                    'Início do Evento',
                    style: TextStyle(color: Colors.blue),
                  )),
              Text('$startTime'),
            ],
          ),
          Row(
            children: <Widget>[
              FlatButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2019, 3, 5),
                        maxTime: DateTime(2200, 6, 7), onChanged: (date) {
                          print('change $date');
                        }, onConfirm: (date) {
                          setState(() {
                            this.endTime = date;
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Text(
                    'Final do Evento',
                    style: TextStyle(color: Colors.blue),
                  )),
              Text('$endTime'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _eventName,
              decoration: InputDecoration(hintText: 'Digite nome do evento'),
            ),
          ),
          RaisedButton(
              child: Text(
                'Insira Evento',
              ),
              color: Colors.grey,
              onPressed: () {
                calendarClient.insert(
                  _eventName.text,
                  startTime,
                  endTime,
                );
                _showDialog(_eventName.text, startTime);
          }),
          // ListView.builder(
          //   itemCount: calendarClient.length,
          //   itemBuilder: (BuildContext context, int i) {
          //   //var doc = snapshot.data.docs[i];
          //   //var item = doc.data;
          //
          //   //print('agenda/${widget.doc.reference.id}');
          //
          //   return Container(
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     margin: const EdgeInsets.all(5),
          //     child: ListTile(
          //       title: Text(_eventName.text),
          //       subtitle: Text(startTime.toString()),
          //       trailing: CircleAvatar(
          //         backgroundColor: Colors.red[300],
          //         foregroundColor: Colors.white,
          //     ),
          //   ));
          // }),
        ],
      ),
    );
  }

  void _showDialog(String evento, DateTime inicio) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Evento Salvo'),
            actions: <Widget>[
              Text('$evento as $inicio'),
              FlatButton(
                child: Text('Ok'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}