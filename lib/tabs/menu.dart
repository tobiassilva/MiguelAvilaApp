import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miguel_avila_app/agendamento/agendamento_page.dart';
import 'package:miguel_avila_app/agendamento/agendamento_page_web.dart';
import 'package:miguel_avila_app/clinicas/clinicas_page.dart';
import 'package:miguel_avila_app/home/home_page.dart';
import 'package:miguel_avila_app/globals.dart' as globals;
import 'package:miguel_avila_app/login/loginGoogle.dart';
import 'package:miguel_avila_app/login/login_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miguel_avila_app/minhaConta/minha_conta_page.dart';

class menuLateral extends StatefulWidget {

  @override
  _menuLateralState createState() => _menuLateralState();
}

class _menuLateralState extends State<menuLateral> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                  //Navigator.of(context).pop();
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
                onPressed: () async {
                  var epClinica = globals.storage.getItem('clinicas');
                  print('epClinica: $epClinica');
                  var coneccao = await globals.funcConeccao();
                  //se nao tiver armazenamento local e nao tiver internet
                  if(epClinica == null && coneccao == true){
                    print("nao baixou dados e nao tem internet");
                    _semConeccao();
                  } else {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => clinicasPage())
                    );
                  }


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
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => agendamentoPageWeb())
                  );
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
                onPressed: ()async{
                  //signOutGoogle();
                  /*print(_auth.signOut());
                  Navigator.of(context).removeRoute(MaterialPageRoute(
                      builder: (context) => loginPage()
                  ));*/
                  print(_auth.signOut());
                  await googleSignIn.signOut();
                  Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => loginPage(),
                          settings: RouteSettings(name: 'Login')));
                  /*Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => loginPage()
                        )
                      //ModalRoute.withName('/')
                      );*/
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

  Future<bool> _onWillPop() {
    Navigator.of(context).pop(false);
    print("Teste");
  }

  Future<void> _semConeccao() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return MaterialApp(
          home: WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  height: MediaQuery.of(context).size.height/1.6,
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      border: new Border.all(
                        width: 1.0,
                        color: Colors.transparent,
                      ),
                      borderRadius:
                      new BorderRadius.all(new Radius.circular(20.0))),
                  child: Column(
                    children: <Widget>[


                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[

                              Icon(Icons.signal_wifi_off, size: 150, color: Colors.red,),

                              Row(
                                children: <Widget>[
                                  Flexible(
                                      child: Text(
                                        'Você precisa estar conectado a internet '
                                            'no seu primeiro acesso. Depois, pode'
                                            'entrar mesmo sem internet!',
                                        style: TextStyle(
                                            fontSize: 24, color: globals.corPrimaria,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      )),
                                ],
                              ),

                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) => homePage())
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  width: 150,
                                  //padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                                  //margin: EdgeInsets.only(left: 50, right: 20, bottom: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(30),
                                    //border: Border.all(color: Color.fromRGBO(0, 185, 255, 1), width: 1.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        'FECHAR',
                                        style: TextStyle(fontSize: 18, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),



                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
