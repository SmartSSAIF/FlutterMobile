import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:THAS/servidor.dart';
import 'dart:convert';

class Configuracoes extends StatefulWidget {
  Configuracoes({Key key}) : super(key: key);

  @override
  _Configuracoes createState() => _Configuracoes();
}

class _Configuracoes extends State<Configuracoes> {
  String nome = " ";
  String email = " ";
  final GlobalKey<ScaffoldState> __scaffold = new GlobalKey();

  bool trabalhando = false;

  @override
  void initState() {
    super.initState();

    _data();
    print("Configuracoes get");

    Servidor().get("usuario/isWorking", this.__scaffold).then((e) {
      var resp = jsonDecode(e);
      print("Configuracoes $resp");
      print("Is Working ${resp['isWorking']}");
      setState(() {
        trabalhando = resp['isWorking'] == 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: __scaffold,
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.all(0),
                child: UserAccountsDrawerHeader(
                  accountName: Text(nome),
                  margin: EdgeInsets.all(0),
                  accountEmail: Text(email),
                  currentAccountPicture: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).platform == TargetPlatform.iOS
                              ? Colors.blue
                              : Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          nome.substring(0, 1),
                          style: TextStyle(fontSize: 40.0),
                        ),
                      )),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              Positioned(
                right: 15,
                top: 40,
                child: GestureDetector(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: __toggle,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Trabalhando"),
                          Switch(
                            value: trabalhando,
                            onChanged: __changed,
                          )
                        ],
                      )),
                  Divider(
                    color: Colors.grey,
                    height: 3,
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Informações",
                          style: TextStyle(
                              color: Colors.grey, fontStyle: FontStyle.italic),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[Text("Nome: "), Text(nome)],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[Text("Função:"), Text(".")],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  __changed(value) {}
  __toggle() {
    setState(() {
      trabalhando = !trabalhando;
      var obj = {"isWorking": trabalhando.toString()};
      Servidor().put("usuario/isWorking", obj).then((e) {});
    });
  }

  void _data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Testando ${prefs.getString("nome")}");
    setState(() {
      this.nome = prefs.getString("nome");
      this.email = prefs.getString("email");
    });
  }
}
