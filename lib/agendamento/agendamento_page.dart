import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miguel_avila_app/tabs/appBar.dart';
import 'package:miguel_avila_app/tabs/menu.dart';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;

class agendamentoPage extends StatefulWidget {
  @override
  _agendamentoPageState createState() => _agendamentoPageState();
}

class _agendamentoPageState extends State<agendamentoPage> {
  bool leuBanco = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List jsonServicos = List();
  List jsonProf = List();

  List jsonProfdoServico = List();

  var jsonProfaAux;

  //var servicoParcialEsc;
  var servicoEsc;
  var profissionalEsc;
  
  int opcaoTela = 0; //define em qual tela está (servico, profissional, final)


  void initState() {
    super.initState();

    jsonProf.clear();
    jsonServicos.clear();
    _lerServicosPage();
  }

  Future<String> _lerServicosPage() async {
    var aux = await http.get(
        'https://miguelavila.com.br/novosite/index.php/wp-json/wp/v2/servico');

    var jsonServicosAux = await jsonDecode(aux.body);

    print(jsonServicosAux);

    print(globals.clinicaSelecionada);
    if(globals.clinicaSelecionada == null){
      await _verificaClinicaEscolhida();
    }

    print('PROFISSIONAIS AUX: ${jsonServicosAux.length}');
    for(int i = 0; i < jsonServicosAux.length; i++){
      print("QTDE de servicos da CLINICA: ${globals.clinicaSelecionada['acf']['servicos_disponiveis'].length}");
      for(int j = 0; j < globals.clinicaSelecionada['acf']['servicos_disponiveis'].length; j++){
        print('FOR 2');
        print('FOR 2: ${jsonServicosAux[i]['acf']}');
        print('ID SERVICOOOOOOOOOOOOO: ${globals.clinicaSelecionada['acf']['servicos_disponiveis'][j]['ID']}');
        if(jsonServicosAux[i]['id'] == globals.clinicaSelecionada['acf']['servicos_disponiveis'][j]['ID']){
          print('LEU 1');
          print('PROFISSIONAIS lido: ${jsonServicosAux[i]}');
          jsonServicos.add(jsonServicosAux[i]);
          print('PROFISSIONAIS PASSADO: ${jsonProf}');
        }
      }
    }

    _lerProfissionalWP();
    return 'sucesso';
  }

  Future<String> _lerProfissionalWP() async {
    var aux = await http.get(
        'https://miguelavila.com.br/novosite/index.php/wp-json/wp/v2/profissional');

    jsonProfaAux = await jsonDecode(aux.body);

    print(jsonProfaAux);


    //Le os profissionais
    print('PROFISSIONAIS AUX: ${jsonProfaAux.length}');
    for(int i = 0; i < jsonProfaAux.length; i++){
      print("QTDE de clinicas que atende: ${jsonProfaAux[i]['acf']['clinicas_que_atende'].length}");
      for(int j = 0; j < jsonProfaAux[i]['acf']['clinicas_que_atende'].length; j++){
        print('FOR 2');
        print('FOR 2: ${jsonProfaAux[i]['acf']['clinicas_que_atende'][j]['ID']}');
        print('ID CLINICAAAAAAAAAAAAAAAAAA: ${globals.clinicaSelecionada['id']}');
        if(
              jsonProfaAux[i]['acf']['clinicas_que_atende'][j]['ID'] == globals.clinicaSelecionada['id'] &&
              jsonProfaAux[i]['acf']['servicos_que_atende'] != null
        ){  //Se p ´rpfissional atende na clinica escolhida && Atende pelo menos 1 serviço
          print('LEU 1');
          print('PROFISSIONAIS lido: ${jsonProfaAux[i]}');
          jsonProf.add(jsonProfaAux[i]);
          print('PROFISSIONAIS PASSADO: ${jsonProf}');
        }
      }
    }

    print("PROFISSIONAIS: ${jsonProf.length}");

    print(globals.clinicaSelecionada);
    setState(() {
      leuBanco = true;
    });

    return 'sucesso';
  }

  Future<String> _verificaClinicaEscolhida() async {
    var aux = await http.get(
        'https://miguelavila.com.br/novosite/index.php/wp-json/wp/v2/clinica');

    print('entrooou');
    var jsonClinica = await jsonDecode(aux.body);

    globals.clinicaSelecionada = await jsonClinica[0];

    print('ID CLINICAAAAAAAAAAAAAAAAAA: ${globals.clinicaSelecionada}');


    return 'sucesso';
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
                          children: <Widget>[
                            Divider(
                              height: 14,
                              color: Colors.transparent,
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    opcaoTela == 0 ? 'Selecione um Serviço' :
                                    opcaoTela == 1 ? 'Selecione um Profissional' :
                                    'Concluido',

                                    style: TextStyle(
                                        fontSize: 28,
                                        color: globals.corPrimaria),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 34,
                              color: Colors.transparent,
                            ),

                            ///TELA SERVICO OU PROFISSIONAL OU CONCLUIDO
                            opcaoTela == 0 ? opcaoTelaServicos() :
                            opcaoTela == 1 ? opcaoTelaP() :
                                opcaoTelaFinal(),

                            Divider(
                              height: 15,
                              color: Colors.transparent,
                            ),

                            //DIVISÓRIA

                            Container(
                              margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                              decoration: BoxDecoration(
                                  color: Colors.black26,
                                  border: Border.all(width: 1.5, color: Colors.black26)),
                            ),

                            Divider(
                              height: 25,
                              color: Colors.transparent,
                            ),

                            selecionaData(),





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

  Widget opcaoTelaServicos(){

      return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: jsonServicos.length,
          itemBuilder: (BuildContext cont, index) {
            return _listaDeServicos(cont, index);
          });

  }

  Widget opcaoTelaP(){
      return Column(
        children: <Widget>[
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: jsonProfdoServico.length,
              itemBuilder: (BuildContext cont, index) {
                return _listaDeProfissionais(cont, index);
              }),

          Divider(
            height: 20,
            color:Colors.transparent
          ),
          GestureDetector(
            onTap: (){
              servicoEsc = null;
              setState((){
                opcaoTela = 0;
              });

            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(FontAwesomeIcons.arrowLeft, size: 20, color: globals.corTexto,),
                Text('  Voltar', style: TextStyle(color: globals.corTexto, fontWeight: FontWeight.bold, fontSize: 15),)
              ],
            ),

          ),
        ],
      );;


  }

  Widget opcaoTelaFinal(){
    var jsonProfissionalAtual = profissionalEsc['acf'];
    String nomeProfissional = profissionalEsc['title']['rendered'];
    var jsonServicoAtual = servicoEsc['acf'];
    String tituloServico = servicoEsc['title']['rendered'];
    return Column(
      children: <Widget>[

        /// TITULO SERVIÇO ESCOLHIDO
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
                child: Text(
                  'Serviço Escolhido',
                  style: TextStyle(
                      fontSize: 20, color: globals.corPrimaria),
                )),
          ],
        ),

        Container(
          padding: const EdgeInsets.only(
              top: 1, left: 30, right: 30),
          margin: EdgeInsets.only(
              left: 0, right: 150, top: 3, bottom: 10),
          decoration: new BoxDecoration(
              color: Colors.black26,
              border: new Border.all(
                width: 1.0,
                color: Colors.transparent,
              ),
              borderRadius: new BorderRadius.all(
                  new Radius.circular(20.0))),
          alignment: Alignment.center,
        ),

        ///SERVIÇO ESCOLHIDO
        Container(
          margin: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              /// Image Serviço
              Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      //color: Colors.red
                      image: DecorationImage(image: AssetImage('assets/images/icons/iconLogo.png'),
                        fit: BoxFit.cover,
                      )
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image(
                      image: jsonServicoAtual['foto'] == null
                          ? AssetImage('assets/images/icons/iconLogo.png')
                          : NetworkImage('${jsonServicoAtual['foto']['link']}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              ///NOME E VALOR DO SERVIÇO
              Expanded(
                child: Container(
                    //color: Colors.green,
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                tituloServico == ''
                                    ? 'Serviço não informado'
                                    : tituloServico,
                                style: TextStyle(
                                    color: globals.corTexto,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                jsonServicoAtual['valor'] == ''
                                    ? 'Valor não informado'
                                    : "R\$ ${jsonServicoAtual['valor']}",
                                style: TextStyle(
                                    color: globals.corTexto, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ),

              /// Informações
              GestureDetector(
                onTap: () {
                  _infos(
                    tituloServico == '' ? 'Descrição do Serviço' : tituloServico,
                    jsonServicoAtual['descricao'],
                    jsonServicoAtual['cuidados_apos_o_procedimento'],
                    jsonServicoAtual['foto'] == null
                        ? AssetImage('assets/images/icons/iconLogo.png')
                        : NetworkImage('${jsonServicoAtual['foto']['link']}'),
                  );
                },
                child: Container(
                  child: Icon(
                    Icons.info_outline,
                    color: globals.corPrimaria,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),

        ///PROFISSIONAL ESCOLHIDO
        Container(
          margin: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              /// Image Profissional
              Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      //color: Colors.red
                      image: DecorationImage(image: AssetImage('assets/images/icons/iconLogo.png'),
                        fit: BoxFit.cover,
                      )
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image(
                      image: jsonProfissionalAtual['foto'] == null
                          ? AssetImage('assets/images/icons/iconLogo.png')
                          : NetworkImage('${jsonProfissionalAtual['foto']['link']}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              ///NOME DO PROFISSIONAL
              Expanded(
                child: Container(
                    //color: Colors.green,
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                nomeProfissional == ''
                                    ? '(Nome Não Informado)'
                                    : nomeProfissional,
                                style: TextStyle(
                                    color: globals.corTexto,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
              ),

            ],
          ),
        ),


        Divider(
            height: 20,
            color:Colors.transparent
        ),
        GestureDetector(
          onTap: (){
            //servicoParcialEsc = null;
            servicoEsc = null;
            profissionalEsc = null;
            setState((){
              opcaoTela = 0;
            });

          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(FontAwesomeIcons.arrowLeft, size: 20, color: globals.corTexto,),
              Text('  Voltar ao início', style: TextStyle(color: globals.corTexto, fontWeight: FontWeight.bold, fontSize: 15),)
            ],
          ),

        ),
      ],
    );
  }

  Widget _listaDeServicos(cont, index) {
    var jsonServicoAtual = jsonServicos[index]['acf'];
    String tituloServico = jsonServicos[index]['title']['rendered'];
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child:
          Row(
            children: <Widget>[
              /// Image Serviço
              GestureDetector(
                onTap: () {
                  /// TODO: ADICIONAR CAMINHO
                  servicoEsc = jsonServicos[index];
                  print('CLICOU IMG');
                  setState((){
                    jsonProfdoServico.clear();
                    for(int i = 0; i < jsonProf.length; i++){
                      for(int j=0; j<jsonProf[i]['acf']['servicos_que_atende'].length; j++){
                        if(jsonProf[i]['acf']['servicos_que_atende'][j]['ID'] == servicoEsc['id']){
                          jsonProfdoServico.add(jsonProf[i]);
                        }
                      }
                    }
                    opcaoTela = 1;
                  });
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      //color: Colors.red
                      image: DecorationImage(image: AssetImage('assets/images/icons/iconLogo.png'),
                        fit: BoxFit.cover,
                      )
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image(
                      image: jsonServicoAtual['foto'] == null
                          ? AssetImage('assets/images/icons/iconLogo.png')
                          : NetworkImage('${jsonServicoAtual['foto']['link']}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              ///NOME E VALOR DO SERVIÇO
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ///TODO: ADICIONAR NAVEGAÇÃO
                    servicoEsc = jsonServicos[index];
                    print('CLICOU IMG');
                    setState((){
                      jsonProfdoServico.clear();
                      for(int i = 0; i < jsonProf.length; i++){
                        for(int j=0; j<jsonProf[i]['acf']['servicos_que_atende'].length; j++){
                          if(jsonProf[i]['acf']['servicos_que_atende'][j]['ID'] == servicoEsc['id']){
                            jsonProfdoServico.add(jsonProf[i]);
                          }
                        }
                      }
                      opcaoTela = 1;
                    });
                  },
                  child: Container(
                    //color: Colors.green,
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                tituloServico == ''
                                    ? 'Serviço não informado'
                                    : tituloServico,
                                style: TextStyle(
                                    color: globals.corTexto,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                jsonServicoAtual['valor'] == ''
                                    ? 'Valor não informado'
                                    : "R\$ ${jsonServicoAtual['valor']}",
                                style: TextStyle(
                                    color: globals.corTexto, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// Informações
              GestureDetector(
                onTap: () {
                  _infos(
                    tituloServico == '' ? 'Descrição do Serviço' : tituloServico,
                    jsonServicoAtual['descricao'],
                    jsonServicoAtual['cuidados_apos_o_procedimento'],
                    jsonServicoAtual['foto'] == null
                        ? AssetImage('assets/images/icons/iconLogo.png')
                        : NetworkImage('${jsonServicoAtual['foto']['link']}'),
                  );
                },
                child: Container(
                  child: Icon(
                    Icons.info_outline,
                    color: globals.corPrimaria,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),

    );
  }

  Widget _listaDeProfissionais(cont, index) {
    var jsonProfissionalAtual = jsonProfdoServico[index]['acf'];
    String nomeProfissional = jsonProfdoServico[index]['title']['rendered'];
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              /// Image Profissional
              GestureDetector(
                onTap: () {
                  profissionalEsc = jsonProfdoServico[index];
                  print('CLICOU IMG PROF');
                  print('Profissional Escolhido: ${jsonProfdoServico[index]}');
                  setState((){
                    opcaoTela = 2;
                  });
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    //color: Colors.red
                    image: DecorationImage(image: AssetImage('assets/images/icons/iconLogo.png'),
                      fit: BoxFit.cover,
                    )
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image(
                      image: jsonProfissionalAtual['foto'] == null
                          ? AssetImage('assets/images/icons/iconLogo.png')
                          : NetworkImage('${jsonProfissionalAtual['foto']['link']}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              ///NOME DO PROFISSIONAL
              Expanded(
                child: GestureDetector(
                  onTap: () {

                    profissionalEsc = jsonProfdoServico[index];
                    print('CLICOU IMG PROF');
                    print('Profissional Escolhido: ${jsonProfdoServico[index]}');
                    setState((){
                      opcaoTela = 2;
                    });
                  },
                  child: Container(
                    //color: Colors.green,
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                nomeProfissional == ''
                                    ? '(Nome Não Informado)'
                                    : nomeProfissional,
                                style: TextStyle(
                                    color: globals.corTexto,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),


                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }

  Widget selecionaData(){
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(
              child: Text(
                opcaoTela < 3 ? 'Selecione uma Data' :
                opcaoTela == 3 ? 'Selecione um Horário' :
                'Concluido',

                style: TextStyle(
                    fontSize: 28,
                   color: opcaoTela < 2 ? Colors.grey : globals.corPrimaria,
                ),
              ),
            ),
          ],
        ),
        Divider(
          height: 34,
          color: Colors.transparent,
        ),

      ],
    );
  }

  Future<bool> _onWillPop() {
    Navigator.of(context).pop(false);
    print("Teste");
  }


  /// MAIS INFORMAÇÕES
  Future<void> _infos(tituloServico, descricao, cuidados, imagem) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return MaterialApp(
          home: WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                margin: EdgeInsets.fromLTRB(30, 35, 30, 30),
                decoration: new BoxDecoration(
                    color: globals.corSecundaria,
                    border: new Border.all(
                      width: 1.0,
                      color: Colors.transparent,
                    ),
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(20.0))),
                child: Column(
                  children: <Widget>[
                    Container(
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
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            Divider(
                              height: 14,
                              color: Colors.transparent,
                            ),

                            Row(
                              children: <Widget>[
                                Flexible(
                                    child: Text(
                                      tituloServico,
                                      style: TextStyle(
                                          fontSize: 24, color: globals.corPrimaria,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                            Divider(
                              height: 34,
                              color: Colors.transparent,
                            ),

                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image(image: imagem,

                                ),
                              ),
                            ),


                            Divider(
                              height: 34,
                              color: Colors.transparent,
                            ),

                            /// DESCRIÇÃO
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                    child: Text(
                                  'Descrição',
                                  style: TextStyle(
                                      fontSize: 22, color: globals.corPrimaria),
                                )),
                              ],
                            ),

                            Container(
                              padding: const EdgeInsets.only(
                                  top: 1, left: 30, right: 30),
                              margin: EdgeInsets.only(
                                  left: 50, right: 50, top: 3, bottom: 10),
                              decoration: new BoxDecoration(
                                  color: Colors.black26,
                                  border: new Border.all(
                                    width: 1.0,
                                    color: Colors.transparent,
                                  ),
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(20.0))),
                              alignment: Alignment.center,
                            ),

                            Divider(
                              height: 34,
                              color: Colors.transparent,
                            ),


                            Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Text('   $descricao', style: TextStyle(color: globals.corTexto, fontSize: 15),)),

                            Divider(
                              height: 34,
                              color: Colors.transparent,
                            ),

                            ///Cuidados Após o Procedimento
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                    child: Text(
                                  'Cuidados Após o Procedimento',
                                  style: TextStyle(
                                      fontSize: 22, color: globals.corPrimaria),
                                  textAlign: TextAlign.center,
                                )),
                              ],
                            ),

                            Container(
                              padding: const EdgeInsets.only(
                                  top: 1, left: 30, right: 30),
                              margin: EdgeInsets.only(
                                  left: 50, right: 50, top: 3, bottom: 10),
                              decoration: new BoxDecoration(
                                  color: Colors.black26,
                                  border: new Border.all(
                                    width: 1.0,
                                    color: Colors.transparent,
                                  ),
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(20.0))),
                              alignment: Alignment.center,
                            ),

                            Divider(
                              height: 34,
                              color: Colors.transparent,
                            ),


                            Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Text('   $cuidados', style: TextStyle(color: globals.corTexto, fontSize: 15),)),

                            Divider(
                              height: 34,
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
          ),
        );
      },
    );
  }
}
