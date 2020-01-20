import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miguel_avila_app/home/home_page.dart';
import 'package:miguel_avila_app/globals.dart' as globals;

final FacebookLogin fbSignIn = new FacebookLogin();
final FirebaseAuth _auth = FirebaseAuth.instance;
final GlobalKey<ScaffoldState> scaffoldKeyLogin = GlobalKey<ScaffoldState>();

Future<FirebaseUser> signInFacebook(BuildContext context) async{
  FacebookLoginResult result = await fbSignIn.logInWithReadPermissions(['email', 'public_profile']);


  print('result.status: ${result.status}');

  if (result.status == FacebookLoginStatus.loggedIn) {
    print('ENTROOOU');
    FacebookAccessToken myToken = result.accessToken;
    AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: myToken.token);

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    /*FirebaseUser user = (
        await FirebaseAuth.instance.signInWithCredential(credential)
    ).user;*/

    print('user: $user');

    print(myToken.token);

    final notesReference = FirebaseDatabase.instance.reference().child('userProfile/${user.uid}');
    int up = 4;

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

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return homePage();
        },
      ),
    );

    return user;
  }

  return null;

}

Widget buttonFacebook(context){
  return FlatButton(
    onPressed: (){
      signInFacebook(context).whenComplete((){

      }

      );
    },
    child: Container(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.blue, width: 1),
          color: Colors.blueAccent
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(FontAwesomeIcons.facebookF, color: Colors.white,
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