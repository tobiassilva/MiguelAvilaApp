import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:miguel_avila_app/agendamento/agendamento_page.dart';
import 'package:miguel_avila_app/tabs/appBar.dart';
import 'package:miguel_avila_app/globals.dart' as globals;
import 'package:miguel_avila_app/tabs/menu.dart';
import 'package:url_launcher/url_launcher.dart';

class clinicasPage extends StatefulWidget {
  @override
  _clinicasPageState createState() => _clinicasPageState();
}

class _clinicasPageState extends State<clinicasPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool leuBanco = false;

  var jsonClinicas;

  void initState() {
    super.initState();

    verificaCon();


  }

  Future<void> verificaCon() async {
    var coneccao = await globals.funcConeccao();

    print(coneccao);
    if(coneccao == false){ //se tem internet

      _lerClinicasWP();
    } else {
      print('NAO TEM INTERNET MAS CARREGA DO BANCO');
      jsonClinicas = await globals.storage.getItem('clinicas');
      print('jsonClinicas: $jsonClinicas');
      setState(() {
        leuBanco = true;
      });
    }
  }

  Future<String> _lerClinicasWP() async {
    var aux = await http.get(globals.apiClinicas);

    jsonClinicas = await jsonDecode(aux.body);

    globals.storage.setItem('clinicas', jsonClinicas);

    print(jsonClinicas);
    print('nome: ${jsonClinicas[0]['id']}');

    print('QTDE: ${jsonClinicas.length}');

    setState(() {
      leuBanco = true;
    });
    return 'Sucesso';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        drawer: menuLateral(),
        body: leuBanco == false
            ? Column(
                children: <Widget>[
                  appBar(context, scaffoldKey),
                  Expanded(child: Center(child: globals.loading()))
                ],
              )
            : Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    appBar(context, scaffoldKey),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: ListView(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          children: <Widget>[
                            Divider(
                              height: 14,
                              color: Colors.transparent,
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                    child: Text(
                                  'Clinicas Disponíveis',
                                  style: TextStyle(
                                      fontSize: 28, color: globals.corPrimaria),
                                )),
                              ],
                            ),
                            Divider(
                              height: 34,
                              color: Colors.transparent,
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: jsonClinicas.length,
                                itemBuilder: (BuildContext cont, index) {
                                  return cardClinica(cont, index, context);
                                }),

                            Divider(
                              height: 40,
                              color: Colors.transparent,
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

  Widget cardClinica(cont, index, context) {
    var jsonClinicaAtual = jsonClinicas[index]['acf'];
    var clinicaSelecionadaAtual = jsonClinicas[index];
    print('ID ATUAL: $clinicaSelecionadaAtual');
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              print('CLICOU: ${clinicaSelecionadaAtual}');
              globals.clinicaSelecionada = clinicaSelecionadaAtual;
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => agendamentoPage())
              );
            },
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Text('${jsonClinicaAtual['nome']}',
                      style: TextStyle(fontSize: 22, color: globals.corTexto)),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    print('CLICOU: ${clinicaSelecionadaAtual}');
                    globals.clinicaSelecionada = clinicaSelecionadaAtual;
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => agendamentoPage())
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('${jsonClinicaAtual['endereco']}',
                          style:
                              TextStyle(fontSize: 15, color: globals.corTexto)),
                      Text('Telefone: ${jsonClinicaAtual['telefone']}',
                          style:
                              TextStyle(fontSize: 15, color: globals.corTexto)),
                    ],
                  ),
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        if (await canLaunch(
                            'geo: ${jsonClinicaAtual['mapa']['lat']},${jsonClinicaAtual['mapa']['lng']}?q=${jsonClinicaAtual['mapa']['lat']},${jsonClinicaAtual['mapa']['lng']}')) {
                          await launch(
                              'geo: ${jsonClinicaAtual['mapa']['lat']},${jsonClinicaAtual['mapa']['lng']}?q=${jsonClinicaAtual['mapa']['lat']},${jsonClinicaAtual['mapa']['lng']}');
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        height: 40,
                        width: 40,
                        //color: Colors.black,
                        child: Image(
                            image:
                                AssetImage('assets/images/icons/mapsicon.png')),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (await canLaunch(
                            'geo: ${jsonClinicaAtual['mapa']['lat']},${jsonClinicaAtual['mapa']['lng']}?q=${jsonClinicaAtual['mapa']['lat']},${jsonClinicaAtual['mapa']['lng']}')) {
                          await launch(
                              'geo: ${jsonClinicaAtual['mapa']['lat']},${jsonClinicaAtual['mapa']['lng']}?q=${jsonClinicaAtual['mapa']['lat']},${jsonClinicaAtual['mapa']['lng']}');
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          margin: EdgeInsets.only(left: 7),
                          height: 40,
                          width: 40,
                          //color: Colors.black,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image(
                                image: AssetImage(
                                    'assets/images/icons/ubericon.png')),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              print('CLICOU: ${clinicaSelecionadaAtual}');
              globals.clinicaSelecionada = clinicaSelecionadaAtual;
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => agendamentoPage())
              );
            },
            child: Container(
              child: jsonClinicaAtual['fotos'] == null
                  ? Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 1.5,
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/images/icons/iconLogo.png')),
                    borderRadius: BorderRadius.circular(10)
                ),
              )
                  : Container(

                      child: Stack(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width / 1.5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: globals.loadingCircular()),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width / 1.5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image(
                                image: NetworkImage(
                                  '${jsonClinicaAtual['fotos'][0]['url']}',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          index != jsonClinicas.length -1 ? Container(
            margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
            decoration: BoxDecoration(
                color: Colors.black26,
                border: Border.all(width: 1.5, color: Colors.black26)),
          ) : Container(),
        ],
      ),
    );
  }
}
