import 'dart:io';

import 'package:chat_app/models/mensaje.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final textController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool estaEscribiendo = false;
  List<ChatMessage> _messages = [];
  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarhistorial(this.chatService.usuarioPara.uuid);
  }

  void _cargarhistorial(String uuid) async {
    List<Mensaje> chat = await this.chatService.getChat(uuid);
    final history = chat.map((e) => new ChatMessage(
          texto: e.mensaje,
          uuid: e.de,
          animationController: new AnimationController(
              vsync: this, duration: Duration(milliseconds: 0))
            ..forward(),
        ));
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic data) {
    ChatMessage message = new ChatMessage(
      texto: data['mensaje'],
      uuid: data['de'],
      animationController: AnimationController(
          vsync: this, duration: new Duration(milliseconds: 300)),
    );
    setState(() {
      this._messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 14,
              child: Text(
                usuarioPara.nombre.substring(0, 2),
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
            ),
            SizedBox(height: 3),
            Text(
              usuarioPara.nombre,
              style: TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
              physics: BouncingScrollPhysics(),
              reverse: true,
              itemBuilder: (_, i) => _messages[i],
              itemCount: _messages.length,
            )),
            Divider(height: 1),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: textController,
              onSubmitted: _handleSubmit,
              onChanged: (texto) {
                setState(() {
                  if (texto.trim().length > 0) {
                    this.estaEscribiendo = true;
                  } else {
                    this.estaEscribiendo = false;
                  }
                });
              },
              decoration: InputDecoration.collapsed(hintText: 'Enviar mensaje'),
              focusNode: _focusNode,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: Platform.isIOS
                ? CupertinoButton(
                    child: Text('Enviar'),
                    onPressed: estaEscribiendo
                        ? () => _handleSubmit(textController.text.trim())
                        : null,
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: estaEscribiendo
                              ? () => _handleSubmit(textController.text.trim())
                              : null,
                          icon: Icon(
                            Icons.send,
                          )),
                    ),
                  ),
          )
        ],
      ),
    ));
  }

  _handleSubmit(String texto) {
    if (texto.trim().length == 0) {
      return;
    }
    _focusNode.requestFocus();
    textController.clear();
    final chatMessage = new ChatMessage(
      texto: texto,
      uuid: authService.usuario.uuid,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, chatMessage);
    chatMessage.animationController.forward();
    setState(() {
      this.estaEscribiendo = false;
    });
    this.socketService.emit('mensaje-personal', {
      'de': this.authService.usuario.uuid,
      'para': this.chatService.usuarioPara.uuid,
      'mensaje': texto
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
