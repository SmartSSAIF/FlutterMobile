import 'package:THAS/pedidosFinalizados.dart';
import 'package:THAS/telaConfirmacao.dart';
import 'package:THAS/telaPedido.dart';
import 'package:flutter/material.dart';
import 'package:THAS/MainScreen.dart';
import 'package:THAS/Maps.dart';
import 'SearchList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:THAS/configuracoes.dart';
import 'package:THAS/authentication/authentication.dart';
import 'package:THAS/pedidos.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'package:THAS/appbarThas.dart';
import 'package:THAS/veiculos.dart';
import 'dart:convert';

var corButtons = Colors.white;
var corBottomBar = Colors.blue;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'THAS - Transporte Hospitalar Autonomo Suspenso',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'THAS'),
      // initialRoute: "/home",
      routes: {
        "/pedidos": (context) => Pedidos(),
        "/configuracoes": (context) => Configuracoes(),
        "/pedidosFinalizados": (context) => PedidosFinalizados(),
        "/veiculos": (context) => Veiculos()
        // "/confirmarPedido" : (context) =>TelaConfirmacao(),
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');
        if (pathElements[0] != '') {
          return null;
        }
        if (pathElements[1] == 'pedido') {
          return MaterialPageRoute<int>(
            builder: (BuildContext context) => TelaPedido(
                  idPedido: int.tryParse(pathElements[2]),
                ),
          );
        }
        if (pathElements[1] == 'confirmarPedido') {
          return MaterialPageRoute<int>(
            builder: (BuildContext context) => TelaConfirmacao(
                  idPedido: int.tryParse(pathElements[2]),
                ),
          );
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController controller;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static GlobalKey<ScaffoldState> __scaffold = new GlobalKey();

  final widgets = [MainScreen(), SearchList(scaffold: __scaffold), Maps()];
  String nome = " ";
  String email = " ";
  bool userAdmin = false;
  @override
  void initState() {
    super.initState();

    _data();

    Stream<String> fcmStream = _firebaseMessaging.onTokenRefresh;
    fcmStream.listen((token) {
      print("Token $token");
    });

    _firebaseMessaging.configure(onMessage: (message) async {
      print("On message");
      _navigateToItemDetail(message);
    }, onResume: (message) async {
      print("On resume");
      _navigateToItemDetail(message);
    }, onLaunch: (message) async {
      print("on launch");
      _navigateToItemDetail(message);
    });

    _firebaseMessaging.requestNotificationPermissions();
    //print("Token");

    controller = new TabController(length: widgets.length, vsync: this);
  }

  void _navigateToItemDetail(var message) {
    final String pagechooser = message['data']['screen'];
    //print("Tela $pagechooser");

    Function f = () {
      controller.animateTo(2);
    };

    switch (pagechooser) {
      case 'map':
        print("Controller map");
        f = () {
          controller.animateTo(2);
        };
        break;
      case 'search':
        print("Controller search");
        f = () {
          controller.animateTo(1);
        };
        break;
      case 'home':
        print("Controller home");
        f = () {
          controller.animateTo(0);
        };
        break;
      default:
        print("Navigator $pagechooser");
        new Timer(const Duration(seconds: 1), () {
          Navigator.pushNamed(context, pagechooser);
        });
        break;
    }

    new Timer(const Duration(seconds: 1), f);
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
      key: __scaffold,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: appbar(context),
      drawer: Drawer(
          child: ListView(
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
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Principal'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Pedidos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/pedidos");
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Pedidos finalizados'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/pedidosFinalizados");
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configurações'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/configuracoes");
            },
          ),
          userAdmin
              ? ListTile(
                  leading: Icon(Icons.list),
                  title: Text('Veículos'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/veiculos");
                  },
                )
              : Text(""),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sair'),
            onTap: () {
              authenticationBloc.dispatch(LoggedOut());
            },
          ),
        ],
      )),
      body: new TabBarView(
        children: widgets,
        controller: controller,
      ),
      bottomNavigationBar: new Material(
        color: corBottomBar,
        child: new TabBar(
          tabs: <Tab>[
            new Tab(
              // set icon to the tab
              icon: Icon(
                Icons.home,
                color: corButtons,
              ),
            ),
            new Tab(
              icon: Icon(Icons.search, color: corButtons),
            ),
            new Tab(
              icon: Icon(Icons.map, color: corButtons),
            )
          ],
          controller: controller,
        ),
      ),
    );
  }

  void _data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //  print("Testando ${prefs.getString("nome")}");
    setState(() {
      if (prefs.getString("token") != null) {
        Map teste = parseJwt(prefs.getString("token"));
        print("Token convertido $teste");
        if (teste['nivel'] == 1) {
          setState(() {
            userAdmin = true;
          });
        }
      }

      if (prefs.getString("nome") != null && prefs.getString("email") != null) {
        this.nome = prefs.getString("nome");
        this.email = prefs.getString("email");
      }
    });
  }
}

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
