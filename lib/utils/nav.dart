
import 'package:flutter/material.dart';

//direciona o fluxo dinamico para outra pagina
Future push(BuildContext context, Widget page, {bool replace = false}) {
  if(replace){//se for true substitui uma widget por outra
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){// substitui a widget por outra ao contrario do push que empilha uma widget por cima da outa
      return page;
    }));

  }
  //se for falso empilha a widget
  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
    return page;
  }));
}
//encapsula a chamada no Navigator.pop
bool pop<T extends Object>(BuildContext context, [T result] ) {
  return Navigator.pop(context);
}