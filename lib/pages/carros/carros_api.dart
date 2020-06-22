import 'dart:convert' as convert;
import 'dart:io';

import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carro_dao.dart';
import 'package:carros/pages/carros/upload_api.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:carros/utils/http_helper.dart' as http;


class TipoCarro {
  static final String classicos = "classicos";
  static final String esportivos = "esportivos";
  static final String luxo = "luxo";

}

class CarrosApi {
  static Future<List<Carro>> getCarros(String tipo) async {

      var url = 'https://carros-springboot.herokuapp.com/api/v2/carros/tipo/$tipo'; //é autenticado

      print("GET > $url");

      var response = await http.get(url);    // http.post retorn um Future(metodo assincrono) vai retornar a chamada no futuro. await fica aguardando este retorno

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
  //salvar o carro na api
  static Future<ApiResponse<bool>> save(Carro c, File file) async {
    try {
      //Antes de salvar o carro faz o upload da foto
      if(file != null) {
        ApiResponse<String> response = await UploadService.upload(file);//salva a foto antes de salvar o carro e retorna a url da foto do carro como string
        if(response.ok) {
          String urlFoto = response.result;//retorna a url da foto
          c.urlFoto = urlFoto;//e atualiza a foto no objeto carro correspondente
        }
      }

      var url = 'https://carros-springboot.herokuapp.com/api/v2/carros';

      if(c.id != null) {//se existir é uma atualizacao do carro um put
        url += "/${c.id}";
      }

      print("POST > $url");

      String json = c.toJson();
      print("json > $json");
      //se for null salva o carro caso contrario atualiza o carro
      var response = await (c.id == null
        ?  http.post(url, body: json)
        :  http.put(url, body: json));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      //salvar retorna 201
      //atualizar 200
      if(response.statusCode == 200 || response.statusCode == 201) {
            Map mapResponse = convert.json.decode(response.body);//converte para map

            Carro carro = Carro.fromMap(mapResponse);//e de map para objeto carro

            print("Novo carro: ${carro.id}");

            return ApiResponse.ok(true);
          }
      //caso devolva um 400 que é um bad request o corpo do body voltara vazio ou null
      if(response.body == null || response.body.isEmpty) {
            return ApiResponse.error("Não foi possível salvar o carro");
          }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(mapResponse["error"]);
    } catch (e) {
      print(e);
      return ApiResponse.error("Não foi possível salvar o carro");
    }
  }

  static delete(Carro c) async {
    try {

      var url = 'https://carros-springboot.herokuapp.com/api/v2/carros/${c.id}';

      print("DELETE > $url");

      var response = await  http.delete(url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if(response.statusCode == 200) {
        return ApiResponse.ok(true);
      }

      return ApiResponse.error("Não foi possível deletar o carro");

    } catch (e) {
      print(e);
      return ApiResponse.error("Não foi possível deletar o carro");
    }
  }
}