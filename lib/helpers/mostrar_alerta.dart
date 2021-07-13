import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mostrarAlerta(BuildContext context, String titulo, String subtitulo) {
  if (Platform.isAndroid) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(titulo),
              content: Text(subtitulo),
              actions: [
                MaterialButton(
                    child: Text('OK'),
                    elevation: 5,
                    textColor: Colors.blue,
                    onPressed: () => Navigator.of(context).pop())
              ],
            ));
    return;
  }

  showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
            title: Text(titulo),
            content: Text(subtitulo),
            actions: [
              CupertinoDialogAction(
                  child: Text('OK'),
                  isDefaultAction: true,
                  onPressed: () => Navigator.of(context).pop())
            ],
          ));
}
