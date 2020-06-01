
import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carro_dao.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class TipoCarro {
  static final String classicos = "classicos";
  static final String esportivos = "esportivos";
  static final String luxo = "luxo";

}

class CarrosApi {
  static Future<List<Carro>> getCarros(String tipo) async {

    Usuario user = await Usuario.get();//pega os dados da pref

    Map<String,String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };

      var url = 'https://carros-springboot.herokuapp.com/api/v2/carros/tipo/$tipo'; //é autenticado

      print("GET > $url");

      var response = await http.get(url, headers: headers);    // http.post retorn um Future(metodo assincrono) vai retornar a chamada no futuro. await fica aguardando este retorno

      String json = response.body;

      List list = convert.json.decode(json); //recebe no formato json e converte para o Objeto List

      //é uma lista que contem vários Map de informação
      //[{}{}{}]

      //list.map() percorre a lista original(dados dos carros) vai mapear a lista para outro tipo
      // .toList() e gera uma nova lista
      //e vai converter para carro
      // (map) => Carro.fromJson(map) funcao de mapeamento
      //percorre a lista [] que dentro da mesma tem vários maps(json de carros) e converte em objeto Carro
      List<Carro> carros = list.map<Carro>((map) => Carro.fromMap(map)).toList();

      return carros;

  }
}