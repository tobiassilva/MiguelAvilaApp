import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


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