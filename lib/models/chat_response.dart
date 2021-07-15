import 'dart:convert';

import 'package:chat_app/models/mensaje.dart';

ChatResponse chatResponseFromJson(String str) => ChatResponse.fromJson(json.decode(str));

String chatResponseToJson(ChatResponse data) => json.encode(data.toJson());

class ChatResponse {
    ChatResponse({
        this.ok,
        this.mensajes,
    });

    bool ok;
    List<Mensaje> mensajes;

    factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(
        ok: json["ok"] == null ? null : json["ok"],
        mensajes: json["mensajes"] == null ? null : List<Mensaje>.from(json["mensajes"].map((x) => Mensaje.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok == null ? null : ok,
        "mensajes": mensajes == null ? null : List<dynamic>.from(mensajes.map((x) => x.toJson())),
    };
}