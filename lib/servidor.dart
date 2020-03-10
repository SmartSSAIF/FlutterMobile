import 'package:THAS/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Servidor {
  final String url = "http://afterthat.com.br:3001/";
  AuthenticationBloc _authenticationBloc = AuthenticationBloc();

  Future<Map<String, String>> _headers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString("token");

    //  print("Token usuario $token");

    Map<String, String> headers = {
      'autenticacao': token,
    };

    return headers;
  }

  Future<String> get(String path, GlobalKey<ScaffoldState> scaffold) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();

    return await http
        .get(
      url + path,
      headers: await _headers(),
    )
        .then((e) {
      print(e.body);
      //var teste = jsonDecode(e.body);
      try {
        print("Servidor $e");
        print("Servidor ${e.body}");
        print("Servidor ${e.statusCode}");
        switch (e.statusCode) {
          case 200:
            return e.body;
            break;
          case 401:
            print("Expirou o token");
            _authenticationBloc.dispatch(LoggedOut());
            return null;
            break;
          case 403:
            break;
          default:
            scaffold.currentState.showSnackBar(
              SnackBar(
                  content: Text("Servidor indisponível. Tente mais tarde")),
            );
            break;
        }
      } catch (f) {
        return e.body;
      }
      return e.body;
    });

    // return resposta;
  }

  Future<String> post(String path, Map<String, dynamic> obj) async {
    return await http
        .post(
      url + path,
      body: obj,
      headers: await _headers(),
    )
        .then((e) {
      return e.body;
    });
  }

  Future<String> put(String path, Map<String, dynamic> obj) async {
    return await http
        .put(url + path, body: obj, headers: await _headers())
        .then((e) {
      return e.body;
    });
  }
}
