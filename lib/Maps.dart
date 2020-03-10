import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

class Maps extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

var infoBool = true;
String origem = "";
String destino = "";

class _MyHomePageState extends State<Maps> {
  GlobalKey<ScaffoldState> __scaffold = new GlobalKey();
  final channel = IOWebSocketChannel.connect('ws://192.168.10.100:5010');

  LatLng posicaoCarro = new LatLng(-21.837355, -46.558870);
  double velocidade = 0;

  @override
  void initState() {
    super.initState();

    channel.stream.listen((onData) {
      print("WS $onData");
      var mensagem = onData;
      setState(() {
        var coordenada = jsonDecode(mensagem);

        try {
          double pLat = coordenada['lugar']['lat'];
          double pLng = coordenada['lugar']['lng'];
          double speed = coordenada['velocidade'].toDouble();
          // String pdestino = coordenada['destino'];

          print("Posicoes  $pLat $pLng");
          posicaoCarro = new LatLng(pLat, pLng);
          velocidade = speed;
          //  destino = pdestino;
        } catch (e) {
          this.__scaffold.currentState.showSnackBar(SnackBar(
                content: Text(e.toString()),
              ));
        }
      });
    }).onError((e) {
      print("Erro WS $e");
      if (mounted)
        __scaffold.currentState.showSnackBar(SnackBar(
          content: Text("Não foi possível conectar ao servidor"),
        ));
    });
  }

  @override
  void dispose() {
    super.dispose();
    channel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: __scaffold,
      body: Stack(
        children: <Widget>[
          new FlutterMap(
            options: new MapOptions(
              center: new LatLng(-21.837165, -46.558870),
              zoom: 20.0,
              maxZoom: 20,
              minZoom: 18.0,
              swPanBoundary: new LatLng(-21.837849, -46.559280),
              nePanBoundary: new LatLng(-21.837050, -46.558717),
            ),
            layers: [
              new TileLayerOptions(
                urlTemplate:
                    "https://thas.smartssa.com.br/mapa/{z}/{x}/{y}.png",
                backgroundColor: Colors.white,
                cachedTiles: true,
              ),
              new MarkerLayerOptions(
                markers: [
                  new Marker(
                    width: 200.0,
                    height: 200.0,
                    point: new LatLng(-21.836958, -46.558877),
                    builder: (ctx) => new Container(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('thasCompleto.png'),
                                // ...
                              ),
                              // ...
                            ),
                          ),
                        ),
                  ),
                  new Marker(
                    width: 30,
                    height: 30,
                    point: posicaoCarro,
                    builder: (ctx) => new Container(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('carro.png'),
                                // ...
                              ),
                              // ...
                            ),
                          ),
                        ),
                  )
                ],
              ),
            ],
          ),
          Positioned(
            left: 5,
            top: 5,
            child: GestureDetector(
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.transparent,
                child: info(),
              ),
              onTap: () {
                setState(() {
                  infoBool = !infoBool;
                });
              },
            ),
          ),
          Positioned(
            right: 5,
            bottom: 5,
            child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    children: <Widget>[
                      Text(
                        velocidade.toString(),
                        style: TextStyle(fontFamily: "Digital", fontSize: 30),
                      ),
                      Text(
                        " Km/h",
                        style: TextStyle(fontFamily: 'Digital', fontSize: 30),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

Widget info() {
  if (infoBool) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: <Widget>[
            //     Text(
            //       "Origem: ",
            //       style: TextStyle(fontSize: 15),
            //     ),
            //     Text(
            //       origem,
            //       style: TextStyle(fontSize: 15),
            //     ),
            //   ],
            // ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Destino: ",
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  destino,
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ],
        ));
  }

  return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Text("Info"));
}
