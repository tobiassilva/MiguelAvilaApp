import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home/home_page.dart';
import 'login/login_page.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'globals.dart' as globals;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(195, 151, 103, 1),
        textSelectionColor: Color.fromRGBO(112, 112, 112, 1),
      ),
      home: carregamentoInicial(),
    );
  }
}

class carregamentoInicial extends StatefulWidget {
  @override
  _carregamentoInicialState createState() => _carregamentoInicialState();
}

class _carregamentoInicialState extends State<carregamentoInicial> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void initState(){
    super.initState();

    getClinicas();

    verificaUsuario();
  }

  Future<String> getClinicas() async {

    var connect = await globals.funcConeccao();

    if(connect == false) { //se esta conectado
      var data = await http.get(
          globals.apiClinicas);

      var jsonAux = jsonDecode(data.body);
      globals.storage.setItem('clinicas', jsonAux);


      return "Sucesso";
    }

    return "erro";

  }



  Future verificaUsuario(){

    _auth.currentUser().then((FirebaseUser user) {
      if (user != null) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) => new homePage(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (context) => new loginPage(),
        ));
      }
    });

  }


  //verifica se ja entrou alguma vez
  /*Future checkPrimeiroAcesso() async {

    SharedPreferences prefer = await SharedPreferences.getInstance();

    bool _seen = (prefer.getBool('seen') ?? false);

    if(_seen){
      _auth.currentUser().then((FirebaseUser user) {
        if (user != null) {
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (context) => new homePage(),
                settings: RouteSettings(name: 'Home')),
          );
        } else {
          Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (context) => new loginPage(),
              settings: RouteSettings(name: 'Login')));
        }
      });
    } else {
      prefer.setBool('seen',
          true); // (feito)  MUDAR PARA TRUE DEPOIS DE PRONTO A PARTE DE CARREGAMENTO

      /*Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (context) => new IntroScreen(),
          settings: RouteSettings(name: 'Intro Screen')));*/
    }
    }*/



  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
