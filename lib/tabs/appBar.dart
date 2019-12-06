import 'package:flutter/material.dart';
import 'package:miguel_avila_app/globals.dart' as globals;

import 'menu.dart';



Widget appBar(context, scaffoldK){
  return Container(
    height: 100,
    width: MediaQuery.of(context).size.width,
    color: globals.corSecundaria,
    child: Row(

      children: <Widget>[
        Container(
          height: 100,
          width: 90,
          color: globals.corPrimaria,
          child: IconButton(
            icon: Icon(Icons.menu, size: 70,),
            color: globals.corSecundaria,
            onPressed: () => scaffoldK.currentState.openDrawer(),
          ),
        ),
        Expanded(
          child: Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Image.asset('assets/images/logo.jpeg'),
            ),
          ),
        ),
      ],
    ),
  );
}
/*
class appBar extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).accentColor,
        child: Row(

          children: <Widget>[
            Container(
              height: 100,
              width: 90,
              color: Theme.of(context).primaryColor,
              child: IconButton(
                icon: Icon(Icons.menu, size: 70,),
                color: Colors.white,
                onPressed: () => globals.scaffoldKey.currentState.openDrawer(),
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Image.asset('assets/images/logo.jpeg'),
                ),
              ),
            ),
          ],
        ),
      );
  }
}
*/