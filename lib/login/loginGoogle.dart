import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:miguel_avila_app/globals.dart' as globals;
import 'package:miguel_avila_app/home/home_page.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String userName;
String userEmail;
String userImageUrl;

Future<String> signInGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  print(user);

  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);

  userName = user.displayName;
  userEmail = user.email;
  userImageUrl = user.photoUrl;

  print('nome: $userName -- email: $userEmail -- image: $userImageUrl ');

  if (userName.contains(" ")) {
    userName = userName.substring(0, userName.indexOf(" "));
  }


  final notesReference = FirebaseDatabase.instance.reference().child('userProfile/${user.uid}');
  int up = 4;
  String nome;
  await notesReference.once().then((DataSnapshot snapshot){
    print('snapshot: ${snapshot.value}');

    ///Se ja tiver logado, mas nao completou o cadastro
    if(snapshot.value != null){

      up = snapshot.value['up'];

    }
    print(up);

  });

  print('UUUUUUUUPPPPPPPPP: $up');

  if(up == 4){
    notesReference.update({'name': user.displayName, 'email': user.email, 'up': 0});
  }



  return 'Login Realizado com Sucesso: $user';
}


void signOutGoogle() async{
  await googleSignIn.signOut();

  print('Usuario deslogou com o Google');
}


Widget buttonGoogle(context){
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
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.red, width: 1),
        color: Colors.red
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(FontAwesomeIcons.google, color: Colors.white,
            size: 40,
          ),
          /*Image(image: AssetImage('assets/images/google_logo.png'), height: 35,),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text('Logar com\nGoogle',
              style: TextStyle(
                color: globals.corTexto,
                fontSize: 16,
              ),
            ),
          ),*/
        ],
      ),
    ),
  );
}