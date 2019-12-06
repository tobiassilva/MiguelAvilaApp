# miguel_avila_app

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


MODELO PAGINA BASE

MaterialApp(
      theme: ThemeData(
        //brightness: Brightness.dark,
        accentColor: Colors.white,
        primaryColor: Color.fromRGBO(195, 151, 103, 1),
        textSelectionColor: Color.fromRGBO(112, 112, 112, 1),
      ),
      home: Scaffold(
        backgroundColor: Colors.red,
        key: globals.scaffoldKey,
        drawer: menuLateral(),
        body: Container(
          color: Colors.white,
          child: Column(
           children: <Widget>[
             appBar(),
           ],
          ),
        ),
      ),
    );