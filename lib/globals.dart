

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

var corPrimaria = Color.fromRGBO(195, 151, 103, 1);
var corSecundaria = Colors.white;
var corTexto = Color.fromRGBO(112, 112, 112, 1);

Widget loading(){
  return SpinKitFadingCube(
    color: corPrimaria,
  );
}