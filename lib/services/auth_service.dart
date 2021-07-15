import 'dart:convert';

import 'package:chat_app/global/environments.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/models/usuario.dart';

class AuthService with ChangeNotifier {
  
  Usuario usuario;
  bool _loading = false;

  final _storage = new FlutterSecureStorage();

  

  bool get loading => this._loading;

  set loading(bool valor) {
    this._loading = valor;
    notifyListeners();
  }

  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token.toString();
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this.loading = true;
    final data = {'email': email, 'password': password};

    final resp = await http.post(Uri.parse('${Environments.apiUrl}/login'),
        body: json.encode(data), headers: {'Content-Type': 'application/json'});

    this.loading = false;

    if (resp.statusCode == 200) {
      final loginResponse = LoginResponse.fromJson(json.decode(resp.body));
      usuario = loginResponse.usuario;
      await this._guardarToken(loginResponse.token);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<LoginResponse> create(
      String email, String password, String nombre) async {
    this.loading = true;
    final data = {'email': email, 'password': password, 'nombre': nombre};

    final resp = await http.post(Uri.parse('${Environments.apiUrl}/login/new'),
        body: json.encode(data), headers: {'Content-Type': 'application/json'});

    this.loading = false;

    if (resp.statusCode == 200) {
      final loginResponse = LoginResponse.fromJson(json.decode(resp.body));
      usuario = loginResponse.usuario;
      await this._guardarToken(loginResponse.token);
      return loginResponse;
    } else {
      return LoginResponse.fromJson(json.decode(resp.body));
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');
    if (token == null) {
      return false;
    }
    final resp = await http.get(Uri.parse('${Environments.apiUrl}/login/renew'),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final loginResponse = LoginResponse.fromJson(json.decode(resp.body));
      usuario = loginResponse.usuario;
      await this._guardarToken(loginResponse.token);
      return true;
    } else {
      this._logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future _logout() async {
    return await _storage.delete(key: 'token');
  }
}
