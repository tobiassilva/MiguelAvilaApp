import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home/home_page.dart';
import 'login/login_page.dart';

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
      home: loginPage(),
    );
  }
}

