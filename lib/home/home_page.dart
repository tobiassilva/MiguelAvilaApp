import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:miguel_avila_app/globals.dart' as globals;
import 'package:miguel_avila_app/minhaConta/cadastroPage.dart';
import 'package:miguel_avila_app/tabs/appBar.dart';
import 'package:miguel_avila_app/tabs/menu.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void initState(){
    super.initState();

    verificaCadastro();

  }

  var user;
  var cadastro;
  var email;
  var displayname;

  Future<FirebaseUser> verificaCadastro() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    user = await _auth.currentUser();
    print(user.uid);

    final notesReference = FirebaseDatabase.instance.reference().child('userProfile/${user.uid}');

    notesReference.once().then((DataSnapshot snapshot){
      cadastro = snapshot.value['up'];
      email = snapshot.value['email'];
      displayname = snapshot.value['name'];
      print(cadastro);
      print(email);
      print(displayname);

      verifica();
    });
  }

  Future<void> verifica() {
    /*Controllers.text = email;
    Controllerss.text = displayname;*/
    print('aqui');
    if (cadastro == 0) { ///Se nao tiver realizado cadastro ainda
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => cadastroPage())
      );
      print('NÃO POSSUI CADASTRO');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: globals.corSecundaria,
        key: scaffoldKey,
        drawer: menuLateral(),
        body: Container(
          color: globals.corSecundaria,
          child: Column(
           children: <Widget>[
             appBar(context, scaffoldKey),
             Stack(
               children: <Widget>[
                 Container(
                   height: MediaQuery.of(context).size.height-100,
                     width: MediaQuery.of(context).size.width,
                     child: Image.asset(
                       'assets/images/img_home.jpeg',
                       fit: BoxFit.cover,
                     ),
                 ),
                 /*Container(
                   height: 200,
                   color: Colors.green,
                 )*/
               ],
             ),
           ],
          ),
        ),
      ),
    );
  }
}