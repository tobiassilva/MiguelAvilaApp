import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miguel_avila_app/globals.dart' as globals;
import 'package:miguel_avila_app/login/loginGoogle.dart';
import 'package:miguel_avila_app/tabs/appBar.dart';
import 'package:miguel_avila_app/tabs/menu.dart';

import 'cadastroPage.dart';

class minhaContaPage extends StatefulWidget {
  @override
  _minhaContaPageState createState() => _minhaContaPageState();
}

class _minhaContaPageState extends State<minhaContaPage> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool leuBanco = false;

  var user;
  var email;
  var displayname;
  int up;
  var cep;
  var bairro;
  var cidade;
  var complemento;
  var estado;
  var logradouro;
  var numero;
  var tel;
  
  void initState(){
    super.initState();
    
    recebeDados();
    //print("$displayname");
    
  }
  
  Future<FirebaseUser> recebeDados() async {
    
    final FirebaseAuth _auth = FirebaseAuth.instance;

    user = await _auth.currentUser();
    
    final dadosFirebase = FirebaseDatabase.instance.reference().child('userProfile/${user.uid}');

    await dadosFirebase.once().then((DataSnapshot snapshot) {
      up = snapshot.value['up'];
      email = snapshot.value['email'];
      displayname = snapshot.value['name'];

      if(snapshot.value['up'] == 1){
        cep = snapshot.value['cep'];
        bairro = snapshot.value['bairro'];
        cidade = snapshot.value['cidade'];
        complemento = snapshot.value['complemento'];
        estado = snapshot.value['estado'];
        logradouro = snapshot.value['logradouro'];
        numero = snapshot.value['numero'];
        tel = snapshot.value['tel'];
      }
    });

    print("${displayname}  ${cidade}");
    setState(() {
      leuBanco = true;
    });


    return user;
  }

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
        backgroundColor: Colors.white,
        key: scaffoldKey,
        drawer: menuLateral(),
        body: leuBanco == false ? Column(
            children: <Widget>[
              appBar(context, scaffoldKey),
              Expanded(child: Center(child: globals.loading()))
            ],
        ) :Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              appBar(context, scaffoldKey),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[

                      Divider(
                        height: 14,
                        color: Colors.transparent,
                      ),

                      Text('Minha Conta', style: TextStyle(fontSize: 28, color: globals.corPrimaria),),

                      Divider(
                        height: 34,
                        color: Colors.transparent,
                      ),
                      ///NOME
                      new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new Text(
                              "NOME",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: globals.corTexto,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.7, color: globals.corTexto)
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: Text('$displayname'),
                            ),
                          ],
                        )
                      ),

                      Divider(
                        height: 24,
                        color: Colors.transparent,
                      ),

                      ///EMAIL
                      new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new Text(
                              "EMAIL",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: globals.corTexto,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.7, color: globals.corTexto)
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Flexible(child: Text('$email')),
                          ],
                        ),
                      ),

                      Divider(
                        height: 24,
                        color: Colors.transparent,
                      ),


                      ///TELEFONE
                      new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new Text(
                              "TELEFONE",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: globals.corTexto,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.7, color: globals.corTexto)
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Flexible(child: Text('$tel')),
                          ],
                        ),
                      ),

                      Divider(
                        height: 24,
                        color: Colors.transparent,
                      ),


                      ///ENDEREÇO
                      Container(
                        child: Center(
                          child: Text(
                            "ENDEREÇO",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: globals.corTexto,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: 24,
                        color: Colors.transparent,
                      ),

                      ///CEP
                      new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new Text(
                              "CEP",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: globals.corTexto,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.7, color: globals.corTexto)
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Flexible(child: Text('$cep')),
                          ],
                        ),
                      ),

                      Divider(
                        height: 24,
                        color: Colors.transparent,
                      ),


                      ///LOGRADOURO
                      new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new Text(
                              "LOGRADOURO",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: globals.corTexto,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.7, color: globals.corTexto)
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Flexible(child: Text('$logradouro')),
                          ],
                        ),
                      ),

                      Divider(
                        height: 24,
                        color: Colors.transparent,
                      ),


                      ///CIDADE
                      new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new Text(
                              "CIDADE",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: globals.corTexto,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.7, color: globals.corTexto)
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Flexible(child: Text('$cidade')),
                          ],
                        ),
                      ),

                      Divider(
                        height: 24,
                        color: Colors.transparent,
                      ),

                      ///CIDADE
                      new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new Text(
                              "CIDADE",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: globals.corTexto,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.7, color: globals.corTexto)
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Flexible(child: Text('$cidade')),
                          ],
                        ),
                      ),

                      Divider(
                        height: 24,
                        color: Colors.transparent,
                      ),

                      ///ESTADO
                      new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new Text(
                              "ESTADO",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: globals.corTexto,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.7, color: globals.corTexto)
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Flexible(child: Text('$estado')),
                          ],
                        ),
                      ),

                      Divider(
                        height: 24,
                        color: Colors.transparent,
                      ),

                      ///NUMERO
                      new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new Text(
                              "NUMERO",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: globals.corTexto,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.7, color: globals.corTexto)
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Flexible(child: Text('$numero')),
                          ],
                        ),
                      ),

                      Divider(
                        height: 24,
                        color: Colors.transparent,
                      ),

                      ///COMPLEMENTO
                      new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new Text(
                              "COMPLEMENTO",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: globals.corTexto,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.7, color: globals.corTexto)
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Flexible(child: Text('$complemento')),
                          ],
                        ),
                      ),

                      Divider(
                        height: 24,
                        color: Colors.transparent,
                      ),


                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[

                            ///SAIR
                            FlatButton(
                              onPressed: (){
                                signOutGoogle();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(FontAwesomeIcons.signOutAlt, color: globals.corTexto,),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text('Sair', style: TextStyle(
                                        color: globals.corTexto,
                                        fontSize: 15
                                    ),),
                                  ),
                                ],
                              )
                            ),

                            ///ATUALIZAR
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => cadastroPage(up))
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                width: 150,
                                //padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                                //margin: EdgeInsets.only(left: 50, right: 20, bottom: 3),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(30),
                                  //border: Border.all(color: Color.fromRGBO(0, 185, 255, 1), width: 1.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Icon(FontAwesomeIcons.userEdit, color: Colors.white,),
                                    Text(
                                      'ATUALIZAR',
                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),


                      Divider(
                        color: Colors.transparent,
                        height: 24,
                      ),



                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
