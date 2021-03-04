import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:agenda_app/pages/PaginaAgenda.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaginaLogin extends StatefulWidget {
  @override
  _PaginaLoginState createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  //TextEditingController _controllerEndereco = TextEditingController();
  TextEditingController _controllerCEP = TextEditingController();
  TextEditingController _controllerTel = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _resultado = "Resultado";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agenda"),
      ),
      body: Form( //consegue armazenar o estado dos campos de texto e além disso, fazer a validação
        key: _formKey, //estado do formulário
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
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
            // TextFormField(
            //   style: TextStyle(
            //     fontSize: 20,
            //     color: Colors.black,
            //   ),
            //   decoration: InputDecoration(
            //       labelText: "Endereço:",
            //       hintText: "Digite seu endereço"
            //   ),
            //   //obscureText: true,
            //   controller: _controllerEndereco,
            //   validator: (String text){
            //     if(text.isEmpty){
            //       return "Digite seu endereço ";
            //     }
            //     if(text.length < 4){
            //       return "Digite novamente";
            //     }
            //     return null;
            //   },
            // ),
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
                      inicializaFirebase();
                      _recuperaCep();
                      await FirebaseFirestore.instance.collection('agenda').add({
                      'Nome': _controllerNome.text,
                      'Email': _controllerEmail.text,
                      // 'Endereço': _controllerEndereco.text,
                      'Endereço': _resultado,
                      'CEP': _controllerCEP.text,
                      'Telefone': _controllerTel.text,
                    });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaginaAgenda()
                        ),
                      );
                    }
                    print("Nome "+_controllerNome.text);
                    print("Email "+_controllerEmail.text);
                    print("Endereço "+_recuperaCep());
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

  _recuperaCep() async{
      String cepDigitado = _controllerCEP.text;
      String url = "https://viacep.com.br/ws/${cepDigitado}/json/";
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

  inicializaFirebase() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }
}
