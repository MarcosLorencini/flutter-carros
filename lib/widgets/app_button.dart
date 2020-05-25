

import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  String text;
  Function onPressed;
  bool showProgress;

  AppButton(this.text, {this.onPressed, this.showProgress=false});

  @override
  Widget build(BuildContext context) {
    return Container(  //envolve o RaisedButton para atuar na cor, altura, largura, margen, padding no botão.
      height: 46,
      child: RaisedButton(
        color: Colors.blue,
        child: showProgress
        ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),//se showProgress for true mostra o circulo
          ),
        )
        : Text(
          text,
          style: TextStyle(
            color: Colors.white, //se showProgress for false mostra o texto
            fontSize: 22,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
