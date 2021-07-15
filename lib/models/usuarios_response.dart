import 'dart:convert';

import 'package:chat_app/models/usuario.dart';

UsuariosResponse usuariosResponseFromJson(String str) =>
    UsuariosResponse.fromJson(json.decode(str));

String usuariosResponseToJson(UsuariosResponse data) =>
    json.encode(data.toJson());

class UsuariosResponse {
  UsuariosResponse({
    this.ok,
    this.usuarios,
  });

  bool ok;
  List<Usuario> usuarios;

  factory UsuariosResponse.fromJson(Map<String, dynamic> json) =>
      UsuariosResponse(
        ok: json["ok"] == null ? null : json["ok"],
        usuarios: json["usuarios"] == null
            ? null
            : List<Usuario>.from(
                json["usuarios"].map((x) => Usuario.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok == null ? null : ok,
        "usuarios": usuarios == null
            ? null
            : List<dynamic>.from(usuarios.map((x) => x.toJson())),
      };
}
