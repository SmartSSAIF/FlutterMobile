import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TelaProduto extends StatelessWidget {
  final String nomeProduto;

  TelaProduto({@required this.nomeProduto});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Equipamentos"),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: 20,
            left: 50,
            child: Center(
              child: Text(
                nomeProduto,
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 30,
            child: Text(
              "Lugar: x",
              style: TextStyle(fontSize: 25),
            ),
          )
        ],
      ),
    );
  }
}
