import 'package:flutter/material.dart';
import 'package:miguel_avila_app/globals.dart' as globals;
import 'package:miguel_avila_app/tabs/appBar.dart';
import 'package:miguel_avila_app/tabs/menu.dart';

class minhaContaPage extends StatefulWidget {
  @override
  _minhaContaPageState createState() => _minhaContaPageState();
}

class _minhaContaPageState extends State<minhaContaPage> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        //brightness: Brightness.dark,
        accentColor: Colors.white,
        primaryColor: Color.fromRGBO(195, 151, 103, 1),
        textSelectionColor: Color.fromRGBO(112, 112, 112, 1),
      ),
      home: Scaffold(
        backgroundColor: Colors.red,
        key: scaffoldKey,
        drawer: menuLateral(),
        body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              appBar(context, scaffoldKey),
            ],
          ),
        ),
      ),
    );
  }
}
