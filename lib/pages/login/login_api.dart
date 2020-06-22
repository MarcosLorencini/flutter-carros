
import 'dart:convert';

import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:http/http.dart' as http; //http é uma variavel para o import variavel usada para fazer um post no http.post


class LoginApi {
  static Future<ApiResponse<Usuario>> login(String login, String senha) async { //async usou await tem que usar o async

   try {

     var url = 'https://carros-springboot.herokuapp.com/api/v2/login';

     Map<String,String> headers = {
       "Content-Type": "application/json"
     };

     Map params = {
       "username": login,
       "password": senha
     };

     String s = json.encode(params); //tem que converter o Map para String
     print(url);
     print(">> $s");

     var response = await http.post(url, body: s, headers: headers);    // http.post retorn um Future(metodo assincrono) vai retornar a chamada no futuro. await fica aguardando este retorno

     print('Response status: ${response.statusCode}');
     print('Response body: ${response.body}');

     Map mapResponse = json.decode(response.body); //recebe no formato json e converte para o Objeto Map

     if(response.statusCode == 200){
       final user = Usuario.fromJson(mapResponse);// fazer parse do usuario

       //salvando usuario logado no Prefs
       user.save();
       return ApiResponse.ok(user);
     }
     return ApiResponse.error(mapResponse["error"]);

   }catch(error, exception) { //erros não esperados
     print("Erro no login $error > $exception");
     
     return ApiResponse.error("Não foi possível fazer o login");

   }

  }
}