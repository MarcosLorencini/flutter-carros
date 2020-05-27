

import 'dart:async';

import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/carro/simple_bloc.dart';
import 'package:carros/pages/login/login_api.dart';
import 'package:carros/pages/login/usuario.dart';

class LoginBloc extends SimpleBloc<bool> {

   Future<ApiResponse<Usuario>> login(String login, String senha) async {

    add(true);//manda um booelan para girar o login

    ApiResponse response = await LoginApi.login(login, senha); // o await converte o Future para boolean

    add(false);

    return response;

  }




}