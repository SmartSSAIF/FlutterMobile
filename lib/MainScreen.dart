import 'package:flutter/material.dart';
import 'DropMenu.dart';
import 'dart:convert';
import 'package:THAS/servidor.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MainScreen> {
  List teste = <String>['Buscar', 'Devolver'];
  List origemList = <String>[" "];
  List destinoList = <String>[" "];
  Map lugaresID = new Map<String, String>();
  String origem = "";
  String destino = "";
  String saida = "Buscar";
  TextEditingController __controller = new TextEditingController();
  bool showInfo = true;
  bool validado = false;

  final GlobalKey<ScaffoldState> __scaffold = new GlobalKey();

  @override
  void initState() {
    super.initState();

    Servidor().get("lugares", __scaffold).then((resp) {
      if (resp != null) {
        List<dynamic> lugares = jsonDecode(resp);
        List lug = new List();
        List<String> list = new List<String>();

        lugares.forEach((e) {
          String nome = e['nome'].toString();
          this.lugaresID[e['nome']] = e['id'].toString();

          lug.add(nome);
          list.add(nome);
        });

        if (this.mounted) {
          setState(() {
            if (list.length > 0) {
              print("Lista aqui $list");
              this.origemList = list;
              this.destinoList = list;
            }

            //print(lug);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        key: this.__scaffold,
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new DropMenu(
                        texto: "Tipo de serviço",
                        list: teste,
                        onDropChange: (newvalue) {
                          setState(() {
                            this.saida = newvalue;
                          });
                        },
                      ),
                      new DropMenu(
                        list: origemList,
                        texto: this.saida == "Buscar"
                            ? "Lugar do produto"
                            : "Local atual",
                        onDropChange: (novo) {
                          setState(() {
                            origem = novo;
                            //            print(origem);
                            __validaPedido();
                          });
                        },
                      ),
                      new DropMenu(
                        list: destinoList,
                        texto: this.saida == "Buscar"
                            ? "Lugar atual"
                            : "Local do objeto",
                        onDropChange: (novo) {
                          setState(() {
                            destino = novo;
                            //          print(origem);
                            __validaPedido();
                          });
                        },
                      ),
                      Text(
                        "Observações",
                        textAlign: TextAlign.left,
                        //   controller: this.__controller,
                      ),
                      Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: TextFormField(
                          decoration: InputDecoration(labelText: "Observações"),
                          controller: this.__controller,
                          maxLines: null,
                        ),
                      ),
                      // GestureDetector(
                      //   child: _expandableList(showInfo),
                      //   onTap: () {
                      //     setState(() {
                      //       showInfo = !showInfo;
                      //     });
                      //   },
                      // ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Material(
                          borderRadius: BorderRadius.circular(30.0),
                          //elevation: 5.0,

                          child: MaterialButton(
                            onPressed: validado ? __enviarPedido : () {},
                            minWidth: 150.0,
                            height: 50.0,
                            color:
                                validado ? Color(0xFF179CDF) : Colors.grey[500],
                            child: Text(
                              "Realizar Pedido",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ));
  }

  __enviarPedido() {
    print(this.__controller.text.toString());
    var obj = {
      "origem": this.lugaresID[origem],
      "destino": this.lugaresID[destino],
      "observacoes": this.__controller.text.toString(),
      "statusPedido": "0",
      "prioridade": "1"
    };
    Servidor().post("pedido", obj).then((e) {
      this.__scaffold.currentState.showSnackBar(
            SnackBar(content: Text("Pedido realizado com sucesso.")),
          );
    });
  }

  __validaPedido() {
    if (destino == "" || origem == "" || destino == origem) {
      validado = false;
    } else {
      validado = true;
    }
  }
}

// Widget _expandableList(bool show) {
//   if (show) {
//     return Container(
//       padding: EdgeInsets.all(10),
//       child: Row(
//         textDirection: TextDirection.rtl,
//         children: <Widget>[
//           Icon(
//             Icons.arrow_drop_down,
//             color: Colors.black,
//           ),
//           Text("Mais Opções"),
//         ],
//       ),
//     );
//   }
//   return Container(
//     padding: EdgeInsets.all(10),
//     // decoration: new BoxDecoration(
//     //     borderRadius: BorderRadius.circular(10.0),
//     //     border: Border.all(color: Colors.black)),
//     child: Column(
//       children: <Widget>[
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           textDirection: TextDirection.rtl,
//           children: <Widget>[
//             Icon(
//               Icons.arrow_drop_up,
//               color: Colors.black,
//             ),
//             Text("Menos Opções"),
//           ],
//         ),
//         Text("Outra opcao"),
//         // Text("Check box")
//       ],
//     ),
//   );
// }
Map<String, dynamic> parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }

  final payload = _decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);
  print("Payload map $payloadMap");
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }

  return payloadMap;
}

String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }

  return utf8.decode(base64Url.decode(output));
}
