import 'dart:async';
import 'package:flutter/material.dart';

import 'package:miguel_avila_app/globals.dart' as globals;
import 'package:miguel_avila_app/tabs/appBar.dart';
import 'package:miguel_avila_app/tabs/menu.dart';
import 'package:webview_flutter/webview_flutter.dart';

class agendamentoPageWeb extends StatefulWidget {
  @override
  _agendamentoPageWebState createState() => _agendamentoPageWebState();
}

class _agendamentoPageWebState extends State<agendamentoPageWeb> {

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: menuLateral(),
      body: Column(
        children: <Widget>[
          appBar(context, scaffoldKey),
          Expanded(
            child: WebView(
              initialUrl: globals.linkAgendar,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController){
                _controller.complete(webViewController);
              },
            ),
          ),
        ],
      ),
    );
  }

}
