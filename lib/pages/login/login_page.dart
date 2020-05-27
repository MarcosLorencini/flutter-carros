import 'dart:async';

import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/carro/home_page.dart';
import 'package:carros/pages/login/login_api.dart';
import 'package:carros/pages/login/login_bloc.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:carros/utils/alert.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/widgets/app_button.dart';
import 'package:carros/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _tLogin = TextEditingController();
  final _tSenha = TextEditingController();
  final _focusSenha = FocusNode();
  final _bloc = LoginBloc();


  @override
  void initState() {//inicia a tela
    //para recuperar o contexto
    super.initState();
    //não pode usar o asunc e o await dentro do initState
    Future<Usuario> future = Usuario.get();//recupera o usuario do prefs
    future.then((Usuario user) {//quado o usuario retornar
      if(user != null) {
        setState(() {//redezema tela pode chamar pois está dentro do StatefulWidget
          _tLogin.text = user.login;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text("Carros")
        ),
      ),
      body: _body(),
    );
  }

  _body() {
    return Form( // consegue pegar o estado do formulario e validar os campos
      key: _formKey, //estado do formulario
      child: Container(  //envolver o ListView em um container para poder atuar no css
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[

            AppText("Login", "Digite o login",
                contoller: _tLogin,
                validator: _validateLogin,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                nextFocus: _focusSenha
            ),

            SizedBox(height: 10,), //espacamento

            AppText("Senha", "Digite a senha",
                password: true,
                contoller: _tSenha,
                validator: _validateSenha,
                keyboardType: TextInputType.number,
                focusNode: _focusSenha
            ),


            SizedBox(height: 20,), //espacamento

            StreamBuilder<bool>( //está monitorando uma stream que é do tipo boleana
              stream: _bloc.stream, //recebe um boolean para girar ou não o login e renderiza somente a parte da tela do StreamBuilder
              builder: (context, snapshot) {
                return AppButton(
                  "Login",
                  onPressed: _onClickLogin,
                  showProgress: snapshot.data ?? false, //gira o login ou não é boolean
                );
              }
            )
          ],
        ),
      ),
    );
  }

  _onClickLogin() async {
    if (!_formKey.currentState.validate()) { //valida o form os campos do form. chama uma função validate(validator: _validateLogin e alidator: _validateSenha) dentro do TextFormField
      return;
    }
    String login = _tLogin.text;
    String senha = _tSenha.text;
    print("Login: $login, Senha: $senha");



    ApiResponse response = await _bloc.login(login, senha); // o await converte o Future para boolean

    if(response.ok) {

      Usuario user = response.result; //é o usuario declado como generico
      print(">>> $user");
      push(context, HomePage(), replace: true);//o push impilha as widgets, por baixo vai ficar a login page e por cima a homepage. por padrão é false, fica o botão de retorno na prox, tela
    } else {
      alert(context, response.msg); //manda um booelan para parar de girar o login
    }




  }

  String _validateLogin(String text) {
    if (text.isEmpty) {
      return "Digite o login";
    }
    return null;
  }

  String _validateSenha(String text) {
    if (text.isEmpty) {
      return "Digite a senha";
    }
    if (text.length < 3) {
      return "A senha precisa ter pelo menos 3 números";
    }
    return null;
  }

  void dispose() {//libera o widget da memoria
    super.dispose();
    _bloc.dispose();//fecha a stream que é o fluxo de dados
  }
}
