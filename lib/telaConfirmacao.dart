import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'servidor.dart';

class TelaConfirmacao extends StatefulWidget {
  final int idPedido;
  TelaConfirmacao({Key key, this.idPedido}) : super(key: key);

  @override
  __TelaConfirmacao createState() => __TelaConfirmacao();
}

class __TelaConfirmacao extends State<TelaConfirmacao> {
  GlobalKey<ScaffoldState> _scaffold = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffold,
        appBar: AppBar(
          title: Text("Confirmação de entrega"),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("O objeto foi entregue?"),
              MaterialButton(
                onPressed: () {
                  Servidor().put(
                      "finalizarPedido", {'id': widget.idPedido.toString(), 'statusPedido' : '7'}).then((e) {
                    Navigator.pop(context);
                  });
                },
                minWidth: 150.0,
                height: 50.0,
                color: Colors.blue, //Color(0xFFCC0000),
                child: Text(
                  "Confirmar Pedido",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
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
                        this._scaffold.currentState.showSnackBar(SnackBar(
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
                        this._scaffold.currentState.showSnackBar(SnackBar(
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
                        this._scaffold.currentState.showSnackBar(SnackBar(
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
            ],
          ),
        ));
  }
}
