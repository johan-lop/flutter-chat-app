import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String ruta;
  final String pregunta;
  final String textoLink;

  const Labels(
      {Key key,
      this.ruta,
      this.pregunta,
      this.textoLink})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            pregunta,
            style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, ruta);
            },
            child: Text(
              textoLink,
              style: TextStyle(
                  color: Colors.blue[600],
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
