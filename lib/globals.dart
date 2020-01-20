

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localstorage/localstorage.dart';

String linkAgendar = 'https://miguelavila.com.br/novosite/?page_id=393';
String apiClinicas = 'https://miguelavila.com.br/novosite/?rest_route=/wp/v2/clinica';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

var corPrimaria = Color.fromRGBO(195, 151, 103, 1);
var corSecundaria = Colors.white;
var corTexto = Color.fromRGBO(112, 112, 112, 1);

var clinicaSelecionada = null;

bool carregando = false; //verifica se esta carregando dados, se estiver em true fica rodando um loading na tela

Widget loading(){
  return SpinKitFadingCube(
    color: corPrimaria,
  );
}

Widget loadingCircular(){
  return Center(
    child: Container(
      width: 60,
      height: 60,
      child: CircularProgressIndicator(

      ),
    ),
  );
}


String validateEmail(String value) {
  String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "Informe um Email!";
  } else if(!regExp.hasMatch(value)){
    return "Email inválido";
  }else {
    return null;
  }
}

//acessa armazenamento local
final LocalStorage storage = new LocalStorage("json");

Future<bool> funcConeccao() async {
  var cResult = await (Connectivity().checkConnectivity());

  if(cResult == ConnectivityResult.none){ //se nao tem coneccao
    print('NAO TEM CONECCAO GLOBALS');
    return true;
  } else {
    print('TEM CONECCAO GLOBALS');
    return false;
  }

}