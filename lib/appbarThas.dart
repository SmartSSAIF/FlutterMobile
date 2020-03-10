import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget appbar(BuildContext context) {
  return AppBar(
    title: Text("THAS"),
    actions: <Widget>[
      new IconButton(
          icon: new Image.asset('assets/aclin.png'),
          tooltip: 'Closes application',
          onPressed: () {
            openSite(context, 'http://aclin.com.br');
          }),
      new IconButton(
          icon: new Image.asset('assets/smart.png'),
          tooltip: 'Closes application',
          onPressed: () {
            openSite(context, 'https://smartssa.com.br');
          })
    ],
  );
}

openSite(BuildContext context, String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                title: Text("Erro no navegador"),
                content: Text("Erro ao abrir o navegador"),
              ));
    }
  }
}
