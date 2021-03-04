import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class PaginaAtualizar extends StatefulWidget {
  var id;
  PaginaAtualizar(id);
  @override
  _PaginaAtualizarState createState() => _PaginaAtualizarState();
}

class _PaginaAtualizarState extends State<PaginaAtualizar> {

  // TextEditingController _controllerID = TextEditingController();
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerEndereco = TextEditingController();
  TextEditingController _controllerCEP = TextEditingController();
  TextEditingController _controllerTel = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //var snapshots = FirebaseFirestore.instance.collection('agenda').orderBy('Nome').snapshots();
    final _formKey = GlobalKey<FormState>();

      return Scaffold(
        appBar: AppBar(
          title: Text("Atualizar Contato"),
        ),
        body: Form( //consegue armazenar o estado dos campos de texto e além disso, fazer a validação
          key: _formKey, //estado do formulário
          child: ListView(
            padding: EdgeInsets.all(16),
            children: <Widget>[
              // TextFormField(
              //   style: TextStyle(
              //     fontSize: 20,
              //     color: Colors.black,
              //   ),
              //   decoration: InputDecoration(
              //       labelText: "ID do Contato:",
              //       hintText: "Digite ID"
              //   ),
              //   controller: _controllerID,
              //   validator: (String text){
              //     if(text.isEmpty){
              //       return "Digite o texto";
              //     }
              //     return null;
              //   },
              // ),
              // SizedBox(height: 10,),
              TextFormField(
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    labelText: "Nome:",
                    hintText: "Digite seu nome"
                ),
                controller: _controllerNome,
                validator: (String text){
                  if(text.isEmpty){
                    return "Digite o texto";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    labelText: "Email:",
                    hintText: "Digite seu email"
                ),
                controller: _controllerEmail,
                validator: (String text){
                  if(text.isEmpty){
                    return "Digite o texto";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    labelText: "Endereço:",
                    hintText: "Digite seu endereço"
                ),
                //obscureText: true,
                controller: _controllerEndereco,
                validator: (String text){
                  if(text.isEmpty){
                    return "Digite seu endereço ";
                  }
                  if(text.length < 4){
                    return "Digite novamente";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    labelText: "CEP:",
                    hintText: "Digite seu CEP"
                ),
                controller: _controllerCEP,
                validator: (String text){
                  if(text.isEmpty){
                    return "Digite o texto";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    labelText: "Telefone:",
                    hintText: "Digite seu telefone"
                ),
                controller: _controllerTel,
                validator: (String text){
                  if(text.isEmpty){
                    return "Digite o texto";
                  }
                  return null;
                },
              ),
              Container(
                height: 46,
                child: RaisedButton(
                    color: Colors.green,
                    child: Text("Salvar",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white
                      ),),
                    onPressed:() async {
                      if (_formKey.currentState.validate()) {
                        await FirebaseFirestore.instance.collection("agenda").doc(widget.id).update({
                          'Nome': _controllerNome.text,
                          'Email': _controllerEmail.text,
                          'Endereço': _controllerEndereco.text,
                          'CEP': _controllerCEP.text,
                          'Telefone': _controllerTel.text,});
                      }
                      print("Nome "+_controllerNome.text);
                      print("Email "+_controllerEmail.text);
                      print("Endereço "+_controllerEndereco.text);
                      print("CEP "+_controllerCEP.text);
                      print("Telefone "+_controllerTel.text);
                    }
                ),
              ),
            ],
          ),
        ),
      );
    }
}