import 'package:flutter/material.dart';
import 'package:THAS/servidor.dart';
import 'dart:convert';
import 'package:THAS/pedido.dart';
import 'package:THAS/telaPedido.dart';

class Pedidos extends StatefulWidget {
  Pedidos({Key key}) : super(key: key);

  @override
  __Pedidos createState() => __Pedidos();
}

class __Pedidos extends State<Pedidos> {
  ScrollController _scrollController;
  List<Pedido> items = new List<Pedido>();
  int posicao = 0;
  final GlobalKey<ScaffoldState> __scaffold = new GlobalKey();

  @override
  void initState() {
    super.initState();

    Servidor().get("pedido", __scaffold).then((e) {
      var lista = jsonDecode(e);

      print("lista $lista");
      print("zero ${lista[0]}");

      for (var i = 0; i < lista.length; i++) {
        print("Posicao $i");
        print("Teste ${lista[i]}");
        setState(() {
          items.add(Pedido.fromJson(lista[i]));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: __scaffold,
        appBar: AppBar(
          title: Text("Pedidos"),
        ),
        body: ListView.builder(
          physics: ClampingScrollPhysics(),
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${items[index].origem} -> ${items[index].destino}'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TelaPedido(
                              idPedido: items[index].id,
                              pedido: items[index],
                            )));
              },
            );
          },
        ));
  }
}
