import 'dart:async';

import 'package:carros/pages/carros/simple_bloc.dart';
import 'package:http/http.dart' as http;

//o bloc contem a logica
class LoripsumBloc extends SimpleBloc<String> {

  static String lorim;

  fetch() async {
    try {
      String s = lorim ?? await LoripsumApi.getLoripsum(); // na 1x estara vazio ele vai acessar a api na 2x a informação já está guardada na variável lorim

      lorim = s;

      add(s); //recebe uma lista de carros
    }catch (e) {
      addError(e);//precisa tratar para cair no StreamBuilder do carros_listView.dart
    }

  }


}

class LoripsumApi {
  static Future<String> getLoripsum() async {

    var url = 'https://loripsum.net/api';

    print("GET > $url");

    var response = await http.get(url);

    String text = response.body;

    text = text.replaceAll("<p>", "");
    text = text.replaceAll("</p>", "");

    return text;

  }
}

