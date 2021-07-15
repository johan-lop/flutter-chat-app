import 'dart:convert';

import 'package:chat_app/models/usuario.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse(
      {this.ok = false, this.usuario, this.token = '', this.msg = ''});

  bool ok;
  Usuario usuario;
  String token;
  String msg;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        ok: json["ok"],
        usuario:
            json["usuario"] != null ? Usuario.fromJson(json["usuario"]) : null,
        token: json["token"] != null ? json["token"] : '',
        msg: json["msg"] != null ? json["msg"] : '',
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuario": usuario?.toJson(),
        "token": token,
        "msg": msg,
      };
}
