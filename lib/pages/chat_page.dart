import 'dart:io';

import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final textController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool estaEscribiendo = false;

  List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 14,
              child: Text(
                'Te',
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
            ),
            SizedBox(height: 3),
            Text(
              'Melisa',
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
      uuid: '123',
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, chatMessage);
    chatMessage.animationController.forward();
    setState(() {
      this.estaEscribiendo = false;
    });
  }

  @override
  void dispose() {
    
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
