import 'package:chat_app_node/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chat_app_node/global/enviroment.dart';
import 'package:chat_app_node/models/login_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  Usuario usuario;
  bool _autenticando = false;

  // Create storage
  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;
  set autenticando(bool autenticando) {
    this._autenticando = autenticando;
    notifyListeners();
  }

  //Getters Y Setters de token 
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this.autenticando = true;

    final data = {'email': email, 'password': password};

    final resp = await http.post('${Enviroment.apiUrl}/login',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    print(resp.body);
    this.autenticando = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuarioDb;
      //Guardar token
      await  this._guardarToken(loginResponse.token);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String nombre, String email, String password) async {
    this.autenticando = true;
    final data = {'nombre': nombre, 'email': email, 'password': password};
    final resp = await http.post('${Enviroment.apiUrl}/login/new',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    this.autenticando = false;

    if(resp.statusCode == 200){
      final registerResponse = loginResponseFromJson(resp.body);//Tomar la respuesta
      this.usuario = registerResponse.usuarioDb;//Tomar el usuario
      await this._guardarToken(registerResponse.token);//Guardar Token
      return true;
    }else{
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key:'token');
    final resp = await http.get('${Enviroment.apiUrl}/login/renew', headers: {
      'Content-Type': 'application/json',
      'x-token': token
    });
    if(resp.statusCode == 200){
      final registerResponse = loginResponseFromJson(resp.body);
      this.usuario = registerResponse.usuarioDb;
      await this._guardarToken(registerResponse.token);
      return true;
    }else{
      this._logout();
      return false;
    }


  }

  Future _guardarToken(String token) async {
    // Write value
    return await _storage.write(key: 'token', value: token);
  }

  Future _logout() async {
    // Delete value
    await _storage.delete(key: 'token');
  }
}
