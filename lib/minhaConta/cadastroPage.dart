import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_correios/flutter_correios.dart';
import 'package:flutter_correios/model/resultado_cep.dart';
import 'package:miguel_avila_app/globals.dart' as globals;
import 'package:miguel_avila_app/home/home_page.dart';
import 'package:miguel_avila_app/tabs/appBar.dart';



class cadastroPage extends StatefulWidget {
  int up;
  cadastroPage(this.up);
  @override
  _cadastroPageState createState() => _cadastroPageState(up);
}

class _cadastroPageState extends State<cadastroPage> {

  int up;
  _cadastroPageState(this.up);

  bool leuBanco = false;

  final GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  final formNome = TextEditingController();
  final formTel = TextEditingController();
  final formEmail = TextEditingController();

  final formCEP = TextEditingController();
  final formLogradouro = TextEditingController();
  final formBairro = TextEditingController();
  final formCidade = TextEditingController();
  final formEstado = TextEditingController();
  final formNumero = TextEditingController();
  final formCompl = TextEditingController();


  int statusCEP = 0;


  void initState(){
    super.initState();

    recebeDados();

  }

  var user;
  Future<FirebaseUser> recebeDados() async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    user = await _auth.currentUser();

    final dadosFirebase =  FirebaseDatabase.instance.reference().child('userProfile/${user.uid}');

    await dadosFirebase.once().then((DataSnapshot snapshot) {

      setState(() {
        formEmail.text = snapshot.value['email'];
        formNome.text = snapshot.value['name'];

        if(snapshot.value['up'] == 1){
          formBairro.text = snapshot.value['bairro'];
          formCidade.text = snapshot.value['cidade'];
          formCompl.text = snapshot.value['complemento'];
          formEstado.text = snapshot.value['estado'];
          formLogradouro.text = snapshot.value['logradouro'];
          formNumero.text = snapshot.value['numero'];
          formTel.text = snapshot.value['tel'];
          formCEP.text = snapshot.value['cep'];


        }
      });
    });

    print(formBairro.text);
    leuBanco = true;
    return user;
}

  String _campoVazio(String value) {
    if (value.isEmpty) {
      return 'Campo nao pode ficar vazio';
    }
  }

  String _validateTel(String value) {
    if (value.length > 11 || value.length < 8) {
      return 'Telefone inválido';
    }
  }

  String _validateCEP(String cep) {
    if (cep.length != 8) {
      return 'CEP deve conter 8 digitos';
    }
  }

  String _validateEmail(String value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Informe um Email!";
    } else if(!regExp.hasMatch(value)){
      return "Email inválido";
    }else {
      return null;
    }
  }


  ResultadoCEP jsonCep;
  Future<String> consultarCEP() async {

    String cepCons = formCEP.text;
    print(cepCons.length);
    if (cepCons.length != 8) {
      _scaffoldState.currentState
          .showSnackBar(new SnackBar(content: Text('CEP Inválido')));
      print('INVALIDO');
      setState(() {
        statusCEP = 0;
      });
    } else {
      try {
        final response = await http
            .get("https://api.postmon.com.br/v1/cep/${formCEP.text}",
            headers: {
              "Content-Type": "text/json; charset=utf-8"
            }); //Criar um loading enquanto o carregamento esta sendo feito (Ex.: se nao tem internet)
        if (response.statusCode == 200) {
          jsonCep = ResultadoCEP(response.body); //Atualiza jsonCep com o endereco completo

          print("jsonCep: $jsonCep");


            setState(() {
              ///TODO: VERIFICAR QUANDO O VALOR FOR NULL. EX.: CEP 37507000
              //LOGRADOURO
              print(formLogradouro.text);
              //textLogradouro = jsonCep.logradouro.toString(); // valor que será mostrado no textField
              formLogradouro.text = jsonCep.logradouro.toString(); // Atualiza Controlador
              print('LOGRADOURO: ${formLogradouro.text}');

              //BAIRRO
              //textBairro = jsonCep.bairro.toString(); // valor que será mostrado no textField
              formBairro.text = jsonCep.bairro.toString(); // Atualiza Controlador

              //CIDADE
              //textCidade = jsonCep.cidade.toString(); // valor que será mostrado no textField
              formCidade.text = jsonCep.cidade.toString(); // Atualiza Controlador

              //ESTADO
              //textEstado = jsonCep.estado.toString(); // valor que será mostrado no textField
              formEstado.text = jsonCep.estado.toString(); // Atualiza Controlador
              statusCEP = 1;
            });

        } else {
          print('NAO  EXISTE');
          setState(() {
            /*textLogradouro = '';
            textBairro = '';
            textCidade = '';
            textEstado = '';*/

            formEstado.text = '';
            formBairro.text = '';
            formCidade.text = '';
            formLogradouro.text = '';

            _scaffoldState.currentState
                .showSnackBar(new SnackBar(content: Text('CEP inexistente')));
            statusCEP = 0;
          });
        }

        print('jsonCep');
        print(jsonCep);

      } catch (e) {
        print(e);
      }
      //return jsonCep;
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: globals.corSecundaria,
        key: _scaffoldState,
        appBar: AppBar(
          title: Text('Atualizar Dados'),
          backgroundColor: globals.corPrimaria,
          centerTitle: true,
        ),
        body: leuBanco == false ? Column(
          children: <Widget>[
            Expanded(child: Center(child: globals.loading()))
          ],
        ) : Container(
          /*decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/img_fundo.jpeg', ),
              fit: BoxFit.cover
            ),
          ),*/
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Form(
            key: formKey,
            child: ListView(
              children: <Widget>[
                Divider(
                  height: 15,
                  color: Colors.transparent,
                ),
                Column(
                  children: <Widget>[
                    new Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 1.9,
                      //padding: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
                      child: new Image.asset(
                        'assets/images/logo.jpeg',
                        //fit: BoxFit.none,
                      ),
                      alignment: Alignment.center,
                    ),
                  ],
                ),
                Divider(
                  height: 15,
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
                    border: Border.all(width: 1, color: globals.corTexto)
                  ),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: TextFormField(
                    obscureText: false,
                    controller: formNome,
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      //border: InputBorder.none,
                      hintText: 'João Ribeiro',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    validator: this._campoVazio,
                  ),
                ),
                Divider(
                  height: 25,
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
                      border: Border.all(width: 1, color: globals.corTexto)
                  ),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: TextFormField(
                    validator: this._validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    controller: formEmail,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'email@email.com',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                ),

                Divider(
                  height: 25,
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
                    border: Border.all(width: 1, color: globals.corTexto)
                ),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(),
                    obscureText: false,
                    controller: formTel,
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0099999999',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    validator: this._validateTel,
                  ),
                ),
                Divider(
                  height: 25,
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
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: <Widget>[
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
                            border: Border.all(width: 1, color: globals.corTexto)
                        ),
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: TextFormField(
                          keyboardType: TextInputType.numberWithOptions(),
                          obscureText: false,
                          controller: formCEP,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '00.000-000',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          validator: this._validateCEP,
                        ),
                      ),
                      Divider(
                        height: 15,
                        color: Colors.transparent,
                      ),
                      Center(
                        child: Container(
                          width: 200,
                          child: FlatButton(
                            onPressed: () => {
                              setState((){
                               statusCEP = 2;
                            }),
                              consultarCEP()
                            },
                            child: new Container(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),/*const EdgeInsets.symmetric(
                                vertical: 15.0,
                                horizontal: 15.0,
                              ),*/
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: globals.corPrimaria,
                                border: Border.all(width: 0.6)
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(FontAwesomeIcons.mapMarkedAlt, color: globals.corSecundaria,),
                                  Text(
                                      "Verificar CEP *",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: globals.corSecundaria,
                                          fontWeight: FontWeight.bold),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
            ],
          ),
                ),
                      Divider(
                        height: 24,
                        color: Colors.transparent,
                      ),
                      Container(
                        child: statusCEP == 0
                            ? Container():
                            statusCEP == 2 ? Center(
                              child: Container(
                                  width: 60,
                                  height: 60,
                                  child: CircularProgressIndicator(

                                  ),
                            ),
                            )
                            : Column(
                          children: <Widget>[
                            ///LOGRADOURO
                            new Row(
                              children: <Widget>[
                                new Expanded(
                                  child: new Text(
                                    "Logradouro",
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
                                  border: Border.all(width: 1, color: globals.corTexto)
                              ),
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: TextFormField(
                                obscureText: false,
                                controller: formLogradouro,
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Rua São José',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                validator: this._campoVazio,
                              ),
                            ),
                            Divider(
                              height: 24,
                              color: Colors.transparent,
                            ),
                            ///BAIRRO
                            new Row(
                              children: <Widget>[
                                new Expanded(
                                  child: new Text(
                                    "Bairro",
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
                                  border: Border.all(width: 1, color: globals.corTexto)
                              ),
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: TextFormField(
                                  obscureText: false,
                                  controller: formBairro,
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Centro',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  validator: this._campoVazio),
                            ),
                            Divider(
                              height: 24,
                              color: Colors.transparent
                            ),
                            ///CIDADE
                            new Row(
                              children: <Widget>[
                                new Expanded(
                                  child: new Text(
                                    "Cidade",
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
                                  border: Border.all(width: 1, color: globals.corTexto)
                              ),
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: TextFormField(
                                  enabled: false,
                                  obscureText: false,
                                  controller: formCidade,
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'São José dos Campos',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  validator: this._campoVazio),
                            ),
                            Divider(
                              height: 24,
                              color: Colors.transparent
                            ),
                            ///ESTADO
                            new Row(
                              children: <Widget>[
                                new Expanded(
                                  child: new Text(
                                    "Estado",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:  globals.corTexto,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: globals.corTexto)
                              ),
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: TextFormField(
                                  enabled: false,
                                  obscureText: false,
                                  controller: formEstado,
                                  style: TextStyle(color:  Colors.black),
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'SP',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  validator: this._campoVazio),
                            ),
                            Divider(
                              height: 24,
                              color:Colors.transparent
                            ),
                            ///NUMERO
                            new Row(
                              children: <Widget>[
                                new Expanded(
                                  child: new Text(
                                    "Numero",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:  globals.corTexto,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: globals.corTexto)
                              ),
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: TextFormField(
                                  obscureText: false,
                                  controller: formNumero,
                                  style: TextStyle(color:  Colors.black),
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '012',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  validator: this._campoVazio),
                            ),
                            Divider(
                              height: 24,
                              color: Colors.transparent
                            ),
                            ///COMPLEMENTO
                            new Row(
                              children: <Widget>[
                                new Expanded(
                                  child: new Text(
                                    "Complemento (opcional)",
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
                                  border: Border.all(width: 1, color: globals.corTexto)
                              ),
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: TextFormField(
                                obscureText: false,
                                controller: formCompl,
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'apto., esquina, fundos...',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 24,
                        color: Colors.transparent,
                      ),

                ///TODO: FAZER A VALIDAÇÃO

                 Row(
                   mainAxisAlignment: up == 0 ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                   mainAxisSize: MainAxisSize.max,
                   children: <Widget>[
                     ///Voltar
                     up == 0
                         ? Container():
                     FlatButton(
                         onPressed: (){
                           Navigator.of(context).pop();
                         },
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Icon(FontAwesomeIcons.arrowLeft, color: globals.corTexto,),
                             Padding(
                               padding: EdgeInsets.only(left: 10),
                               child: Text('Voltar', style: TextStyle(
                                   color: globals.corTexto,
                                   fontSize: 15
                               ),),
                             ),
                           ],
                         )
                     ),
                     FlatButton(
                        onPressed: () async {
                          if (formKey.currentState.validate()) {
                              setState(() {
                                print('Válido');
                                enviaDados();
                              });

                          } else {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                                content: Text(
                                    'Formulário Incorreto, Verifique os Campos!')));
                          }
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
                              Icon(FontAwesomeIcons.check, color: Colors.white,),
                              Text(
                                'SALVAR',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                   ],
                 ),

                Divider(
                  height: 15,
                  color: Colors.transparent,
                ),


              ],
            ),
          ),

    ),
    ),
    );
  }



  Future<FirebaseUser> enviaDados() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    user = await _auth.currentUser();
    final notesReference = FirebaseDatabase.instance.reference().child('userProfile/${user.uid}');
    notesReference.update({
      'name': formNome.text,
      'email': formEmail.text,
      'tel': formTel.text,
      'cep': formCEP.text,
      'logradouro': formLogradouro.text,
      'bairro': formBairro.text,
      'cidade': formCidade.text,
      'estado': formEstado.text,
      'numero': formNumero.text,
      'complemento': formCompl.text,
      'up': 1,
    });

    _confirmaEnvio();


    return user;
  }

  Future<bool> _onWillPop() {
    Navigator.of(context).pop(false);
    print("Teste");
  }

  Future<void> _confirmaEnvio() async {
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

                      ///TODO: TIRAR
                      /*Container(
                        height: 40,
                        padding: EdgeInsets.only(right: 15),
                        decoration: new BoxDecoration(
                            color: globals.corPrimaria,
                            borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                  IconData(57676, fontFamily: 'MaterialIcons')),
                            )
                          ],
                        ),
                      ),*/


                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[

                              Icon(FontAwesomeIcons.checkCircle, size: 150, color: Colors.green,),

                              Row(
                                children: <Widget>[
                                  Flexible(
                                      child: Text(
                                        'Dados Salvos com Sucesso!',
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
