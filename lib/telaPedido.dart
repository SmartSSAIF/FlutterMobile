import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:THAS/servidor.dart';
import 'package:THAS/pedido.dart';

class TelaPedido extends StatefulWidget {
  Pedido pedido;
  final int idPedido;
  TelaPedido({Key key, this.pedido, @required this.idPedido}) : super(key: key);

  @override
  __TelaPedido createState() => __TelaPedido();
}

class __TelaPedido extends State<TelaPedido> {
  final GlobalKey<ScaffoldState> __scaffold = new GlobalKey();
  Pedido pedido;
  @override
  void initState() {
    super.initState();

    if (widget.pedido == null) {
      Servidor()
          .get("pedido/id?id=" + widget.idPedido.toString(), __scaffold)
          .then((e) {
        print("Resposta do servidor pelo Pedido id ");

        var json = jsonDecode(e);
        print("Json $json");
        print("Json ${json[0]}");
        var obj = json[0];
        setState(() {
          pedido = Pedido.fromJson(obj);
        });
      });
    } else {
      pedido = widget.pedido;
    }

    print("Tela Pedido ${widget.pedido}");

    //Servidor().get("").then((e){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: __scaffold,
      appBar: AppBar(
        title: pedido != null ? Text("Pedido ${pedido.id}") : Text("Pedido "),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(children: <Widget>[
          __linhaDados("Origem:", pedido != null ? pedido.origem : ""),
          SizedBox(
            height: 20,
          ),
          __linhaDados("Destino:", pedido != null ? pedido.destino : ""),
          SizedBox(
            height: 20,
          ),
          Text(
            "Observações:",
            style: TextStyle(
                color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 20),
          ),
          Text(
            pedido != null ? pedido.observacoes : "",
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                onPressed: () {},
                minWidth: 150.0,
                height: 50.0,
                color: Colors.grey[500], //Color(0xFFCC0000),
                child: Text(
                  "Cancelar pedido",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  var obj = {'id': pedido.id.toString(), "statusPedido": "5"};
                  Servidor().put("pedido", obj).then((e) {
                    print("Finalizado com sucesso");
                    this.__scaffold.currentState.showSnackBar(SnackBar(
                          content: Text("Pedido confirmado"),
                        ));
                  }).catchError((e) {
                    this.__scaffold.currentState.showSnackBar(SnackBar(
                          content: Text(e.toString()),
                          backgroundColor: Colors.red,
                        ));
                  });
                },
                minWidth: 150.0,
                height: 50.0,
                color: Color(0xFF179CDF),
                child: Text(
                  "Confirmar pedido",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 200,
          ),
          Text("Controle do Guincho:"),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Servidor()
                      .post("controleGuincho", {'sentido': '1'}).then((e) {
                    this.__scaffold.currentState.showSnackBar(SnackBar(
                          content: Text("Guincho foi acionado"),
                        ));
                  });
                },
                child: Container(
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      size: 60,
                    ),
                    color: Colors.blue),
              ),
              GestureDetector(
                onTap: () {
                  Servidor()
                      .post("controleGuincho", {'sentido': '2'}).then((e) {
                    this.__scaffold.currentState.showSnackBar(SnackBar(
                          content: Text("Guincho foi acionado"),
                        ));
                  });
                },
                child: Container(
                  child: Icon(
                    Icons.pause,
                    size: 120,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Servidor()
                      .post("controleGuincho", {'sentido': '0'}).then((e) {
                    this.__scaffold.currentState.showSnackBar(SnackBar(
                          content: Text("Guincho foi acionado"),
                        ));
                  });
                },
                child: Container(
                  color: Colors.blue,
                  child: Icon(Icons.keyboard_arrow_down, size: 60),
                ),
              )
            ],
          )
        ]),
      ),
    );
  }

  __linhaDados(String a, String b) {
    return (Row(
      children: <Widget>[
        Text(
          a,
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          b,
          style: TextStyle(fontSize: 20),
        )
      ],
    ));
  }
}
