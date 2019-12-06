import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:miguel_avila_app/home/home_page.dart';
import 'package:miguel_avila_app/globals.dart' as globals;

import 'loginGoogle.dart';

class loginPage extends StatefulWidget {
  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset('assets/images/logo.jpeg'),
            //SizedBox(height: 50),
            _buttonGoogle(),
          ],
        ),
      ),
    );
  }


  Widget _buttonGoogle(){
    return FlatButton(
      onPressed: (){
        signInGoogle().whenComplete((){
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return homePage();
              },
            ),
          );
        }
        );
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: globals.corTexto, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image(image: AssetImage('assets/images/google_logo.png'), height: 35,),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Faça login com o Google',
                style: TextStyle(
                  color: globals.corTexto,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
