import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:THAS/servidor.dart';

class UserRepository {
  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var obj = {"usuario": username, "senha": password};

    print("User repository");
    return await Servidor().post("autenticacao", obj).then((e) {
      print("Resposta servidor $e");
      var resp = jsonDecode(e);
      var token = resp['token'];
      print("Token $token");
      if (resp['token'] != null) {
        prefs.setString('usuario', e);
        prefs.setString('token', token);
        prefs.setString("nome", resp['usuario']);
        prefs.setString("email", resp['email']);
        prefs.setString("id", resp['id'].toString());
        return token;
      } else {
        throw ("Usuario inválido e/ou senha inválido");
      }
    });
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', null);
    prefs.setString("nome", null);
    prefs.setString("id", null);
    await prefs.setString("usuario", null);
    return;
  }

  Future<void> persistToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Escrevendo token $token");
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    await _firebaseMessaging.getToken().then((s) {
      print(s);
      var obj = {'id': prefs.getString("id"), 'token': s};
      print("Firebase obj $obj");
      Servidor().put('usuario', obj).then((e) {
        print("atualizou token");
      });
    });

    return;
  }

  Future<bool> hasToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var user = prefs.getString("usuario");
    if (user != null) {
      return true;
    }

    return false;
  }
}
