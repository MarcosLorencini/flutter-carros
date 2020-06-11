

import 'package:carros/utils/nav.dart';
import 'package:flutter/material.dart';

alert(BuildContext context, String msg, {Function callback}) {
  showDialog(context: context,
      barrierDismissible: false, //ao clicar fora do dialog não fecha o dialog
      builder: (context){
        return WillPopScope( // quando o scope for fazer o pop pela seta de voltar do android ele vai negar
          onWillPop: () async => false, // não fecha o popup pela seta de voltar do android
          child: AlertDialog(
            title: Text("Carros"),
            content: Text(msg),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context); //fecha o alert
                  if(callback != null) {//chama a tela anterior apos salvar um carro
                    callback();
                  }
               },
              )
            ],
          ),
        );
      });

}