
import 'package:carros/pages/login/login_page.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:carros/utils/nav.dart';
import 'package:flutter/material.dart';

class DrawerList extends StatelessWidget {


  //mostra o usuario recuperado no prefs
  UserAccountsDrawerHeader _header(Usuario user) {
    return UserAccountsDrawerHeader(
      accountName: Text(user.nome),
      accountEmail: Text(user.email),
      currentAccountPicture: CircleAvatar(
        backgroundImage: NetworkImage(user.urlFoto),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    Future<Usuario> usuarioGet = Usuario.get(); //le o usuario que foi salvo no prefs

    return SafeArea(// tira o espaço no top do menu lateral
      child: Drawer(// menu lateral
        child: ListView(
          children: <Widget>[
           FutureBuilder<Usuario>(
               future: usuarioGet, builder: (context, snapshot) {
                 Usuario user = snapshot.data;// dados retorno do Future
                 return user != null ? _header(user) : Container();//na 1x o usuario vai estar nullo
               },
           ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text("Favoritos"),
              subtitle: Text("mais informações..."),
              trailing: Icon(Icons.arrow_forward),
              onTap: () { //o listTile tem o onTap por ex para extrair para uma funcao
                print("Item 1");
                Navigator.pop(context); // o Drawer tbm tem que ser fechado
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text("Ajuda"),
              subtitle: Text("mais informações..."),
              trailing: Icon(Icons.arrow_forward),
              onTap: () { //todo listTile tem o onTap por ex para extrair para uma funcao
                print("Item 1");
                Navigator.pop(context); // o Drawer tbm tem que ser fechado
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Logout"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => _onClickLogout(context), //todos listTile tem o onTap por ex para extrair para uma funcao
            ),
          ],
        ),
      ),
    );

  }



  _onClickLogout(BuildContext context) {
    Usuario.clear();//limpa a prefs
    Navigator.pop(context); //fecha o menu lateral
    push(context, LoginPage(), replace: true);//vai destruir a widget home e vai para a tela de login
  }
}
