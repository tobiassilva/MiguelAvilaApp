import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miguel_avila_app/globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:miguel_avila_app/home/home_page.dart';


final email = TextEditingController();
final senha = TextEditingController();
final FirebaseAuth _auth = FirebaseAuth.instance;



Future<FirebaseUser> singInEmai(context, scaffoldKeyLogin) async {

  /*scaffoldKeyLogin.currentState.showSnackBar(
      new SnackBar(content: new Text('Verificando Conta ...'))
  );*/

  print(email.text);
  print(senha.text);

  final AuthResult result = await _auth.signInWithEmailAndPassword(
      email: email.text,
      password: senha.text);


  print("singd in " + result.user.email);

  Navigator.pushReplacement(
    context,
    new MaterialPageRoute(
      builder: (context) => new homePage(),
    ),
  );

  return result.user;

}


