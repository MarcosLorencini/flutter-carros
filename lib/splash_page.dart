import 'package:carros/pages/carros/home_page.dart';
import 'package:carros/pages/login/login_page.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/utils/sql/db_helper.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {//entra aqui somente no momento que reinicia o app
    super.initState();

    //Inicalizar o banco de dados somente 1x a 1a x
    Future futureA = DatabaseHelper.getInstance().db;//chama o DatabaseHelper.getInstance();

    Future futureB = Future.delayed(Duration(seconds: 3));//espera 3 segundos enquanto o futureA inicia o banco de dados. 3 segundos pq o bd é pequeno

    //não pode usar o asunc e o await dentro do initState
    Future<Usuario> futureC = Usuario.get();//recupera o usuario do prefs

    Future.wait([futureA, futureB, futureC]).then((List values){//espera os futures acabar para continuar
      Usuario user = values[2];//imprime o array 3 que é o futureC
      print(">>>>>>>USER: $user");

      if(user != null) {
        print(">>>>>>>HomePage");//quando estiver no app e rodar sem deslogar
        push(context, HomePage(), replace: true);
      } else {
        print(">>>>>>>LoginPage");//quando deslogar e rodar o app
        push(context, LoginPage(), replace: true);
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[200],
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
