import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:agenda_app/pages/PaginaAtualizar.dart';
import 'package:agenda_app/pages/PaginaCalendario.dart';
import 'package:agenda_app/pages/PaginaMap.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaginaAgenda extends StatefulWidget {
  @override
  _PaginaAgendaState createState() => _PaginaAgendaState();
}

class _PaginaAgendaState extends State<PaginaAgenda> {

  String _resultado = "Resultado";

  @override
  Widget build(BuildContext context) {
    var snapshots = FirebaseFirestore.instance.collection('agenda').orderBy('Nome').snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda de Contatos'),
      ),
      backgroundColor: Colors.grey[200],
      body: StreamBuilder(
        stream: snapshots,
        builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot,
            ) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data.docs.length == 0) {
            return Center(child: Text('Nenhum contato ainda'));
          }

          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int i) {
              var doc = snapshot.data.docs[i];
              //var item = doc.data;

              print('agenda/${doc.reference.id}');

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(5),
                child: ListTile(
                  title: Text(doc['Nome']),
                  subtitle: Text(doc['Email']),
                  trailing: CircleAvatar(
                    backgroundColor: Colors.red[300],
                    foregroundColor: Colors.white,
                    // child: Stack(
                    //   children: <Widget>[
                    //     Align(
                    //       alignment: Alignment.bottomLeft,
                    //       child: IconButton(
                    //           icon: Icon(Icons.delete),
                    //           onPressed: () => doc.reference.delete(),
                    //         ),
                    //     ),
                    //     Align(
                    //       alignment: Alignment.center,
                    //       child: IconButton(
                    //           onPressed: () {
                    //             Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) => PaginaAtualizar()
                    //             ),
                    //           );},
                    //           //tooltip: 'Adicionar novo',
                    //           icon: Icon(Icons.arrow_forward)),
                    //     ),
                    //   ],
                    // )
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => doc.reference.delete(),
                    ),
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaginaAtualizar(doc.reference.id)
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
        floatingActionButton: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: new FloatingActionButton(
                heroTag: "btn1",
                onPressed: () => modalCreate(context),
                //tooltip: 'Adicionar novo',
                child: Icon(Icons.add),),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: new FloatingActionButton(
                  heroTag: "btn2",
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaginaCalendario()
                    ),
                  );},
                  //tooltip: 'Adicionar novo',
                  child: Icon(Icons.event)),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: new FloatingActionButton(
                  heroTag: "btn3",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaginaMap()
                      ),
                    );},
                  //tooltip: 'Adicionar novo',
                  child: Icon(Icons.room)),
            ),
          ],
        )
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => modalCreate(context),
      //   //tooltip: 'Adicionar novo',
      //   child: Icon(Icons.add),
      // ),
    );
  }

  modalCreate(BuildContext context) {
    var form = GlobalKey<FormState>();

    var nome = TextEditingController();
    var email = TextEditingController();
    //var endereco = TextEditingController();
    var cep = TextEditingController();
    var tel = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Criar contato rápido'),
          content: Form(
            key: form,
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Nome'),
                  TextFormField(
                    decoration: InputDecoration(
                      //hintText: 'Ex.: Comprar ração',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    controller: nome,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Este campo não pode ser vazio';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Text('Email'),
                  TextFormField(
                    decoration: InputDecoration(
                      //hintText: '(Opcional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    controller: email,
                  ),
                  // Text('Endereço'),
                  // TextFormField(
                  //   decoration: InputDecoration(
                  //     //hintText: '(Opcional)',
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(5),
                  //     ),
                  //   ),
                  //   controller: endereco,
                  // ),
                  Text('CEP'),
                  TextFormField(
                    decoration: InputDecoration(
                      //hintText: '(Opcional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    controller: cep,
                  ),
                  Text('Telefone'),
                  TextFormField(
                    decoration: InputDecoration(
                      //hintText: '(Opcional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    controller: tel,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            FlatButton(
              onPressed: () async {
                _recuperaCep(cep.text);
                if (form.currentState.validate()) {
                  await FirebaseFirestore.instance.collection('agenda').add({
                    'Nome': nome.text,
                    'Email': email.text,
                    'Endereço': _resultado,
                    'CEP': cep.text,
                    'Telefone': tel.text,
                  });

                  Navigator.of(context).pop();
                }
              },
              color: Colors.green,
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  _recuperaCep(String cep) async{
    String url = "https://viacep.com.br/ws/${cep}/json/";
    http.Response response;
    response = await http.get(url);
    Map<String, dynamic> retorno = json.decode(response.body);
    String logradouro = retorno["logradouro"];
    String complemento = retorno["complemento"];
    String bairro = retorno["bairro"];
    String localidade = retorno["localidade"];
    setState(() { //configurar o _resultado
      _resultado = "${logradouro}, ${complemento}, ${bairro}, ${localidade} ";
    });
    /*print("Logradouro: ${logradouro} "
        " complemento: ${complemento}"
        " bairro: ${bairro}"
        " localidade: ${localidade}");*/
  }

}