import 'dart:convert';

import 'package:chat_app/global/environments.dart';
import 'package:chat_app/models/chat_response.dart';
import 'package:chat_app/models/mensaje.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  Usuario usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioId) async {
    try {
      final resp = await http.get(
          Uri.parse('${Environments.apiUrl}/mensajes/$usuarioId'),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      if (resp.statusCode == 200) {
        final mensajesResponse = ChatResponse.fromJson(json.decode(resp.body));
        return mensajesResponse.mensajes;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
