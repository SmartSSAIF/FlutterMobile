import 'dart:convert';

import 'package:THAS/servidor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Veiculos extends StatefulWidget {
  Veiculos({Key key}) : super(key: key);

  _VeiculosState createState() => _VeiculosState();
}

class _VeiculosState extends State<Veiculos> {
  List<dynamic> veiculos = new List();
  GlobalKey<ScaffoldState> __scaffold = new GlobalKey();

  TextStyle detalhes = new TextStyle(fontSize: 15);
  TextStyle veiculo = new TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
  @override
  void initState() {
    super.initState();
    Servidor().get("carro", __scaffold).then((e) {
      print("Resposta servidor $e");
      setState(() {
        veiculos = jsonDecode(e);
        print("Teste aqui ${veiculos[0]['id']}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: __scaffold,
      appBar: AppBar(
        title: Text("Veículos"),
      ),
      body: ListView.builder(
        itemCount: veiculos.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.fromLTRB(10, 15, 15, 15),
            margin: EdgeInsets.all(10),
            decoration: new BoxDecoration(
              border: new Border.all(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: <Widget>[
                Text(
                  "Veículo " + veiculos[index]['id'].toString(),
                  style: veiculo,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "Estado : " + veiculos[index]['descricao'].toString(),
                      style: detalhes,
                    ),
                    Text(
                      "Tensão : " +
                          (veiculos[index]['estado'] == 3 ? " Idle " : "12 V"),
                      style: detalhes,
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
