import 'package:flutter/material.dart';
import 'package:miguel_avila_app/home/home_page.dart';
import 'package:miguel_avila_app/globals.dart' as globals;
import 'package:miguel_avila_app/login/loginGoogle.dart';
import 'package:miguel_avila_app/login/login_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miguel_avila_app/minhaConta/minha_conta_page.dart';

class menuLateral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: globals.corSecundaria,
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Image.asset('assets/images/logo.jpeg'),
            ),
            Divider(
              height: 25,
              color: Colors.transparent,
            ),
            FlatButton(
                onPressed: ()async{
                  //globals.scaffoldKey.currentState.openDrawer();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => homePage(),
                        //settings: RouteSettings(name: 'Home')
                      )
                  );
                },
                child: Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.home, color: globals.corTexto,),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('Home', style: TextStyle(
                        color: globals.corTexto,
                        fontSize: 18
                      ),),
                    ),
                  ],
                )
            ),
            FlatButton(
                onPressed: (){

                },
                child: Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.mapMarkerAlt, color: globals.corTexto),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('Localização', style: TextStyle(
                          color: globals.corTexto,
                          fontSize: 18
                      ),),
                    ),
                  ],
                )
            ),
            FlatButton(
                onPressed: (){

                },
                child: Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.calendarAlt, color: globals.corTexto,),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('Agendar', style: TextStyle(
                          color: globals.corTexto,
                          fontSize: 18
                      ),),
                    ),
                  ],
                )
            ),
            FlatButton(
                onPressed: (){

                },
                child: Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.clock, color: globals.corTexto,),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('Meus Horários', style: TextStyle(
                          color: globals.corTexto,
                          fontSize: 18
                      ),),
                    ),
                  ],
                )
            ),
            FlatButton(
                onPressed: (){
                  //Navigator.of(context).pop();
                  print('MINHA CONTA');
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => minhaContaPage())
                  );
                },
                child: Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.userAlt, color: globals.corTexto,),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('Minha Conta', style: TextStyle(
                          color: globals.corTexto,
                          fontSize: 18
                      ),),
                    ),
                  ],
                )
            ),
            FlatButton(
                onPressed: (){
                  signOutGoogle();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) {
                            return loginPage();
                          }
                      ),
                      ModalRoute.withName('/'));
                },
                child: Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.signOutAlt, color: globals.corTexto,),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('Sair', style: TextStyle(
                          color: globals.corTexto,
                          fontSize: 18
                      ),),
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}
