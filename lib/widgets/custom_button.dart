import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({Key key, this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: this.onPressed,
      style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          onPrimary: Colors.white,
          shadowColor: Colors.black,
          elevation: 5,
          shape: StadiumBorder()),
      child: Container(
          width: double.infinity,
          height: 55,
          child: Center(
              child: Text(
            this.text,
            style: TextStyle(color: Colors.white, fontSize: 17),
          ))),
    );
  }
}
