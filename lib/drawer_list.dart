
import 'package:carros/pages/login/login_page.dart';
import 'package:carros/utils/nav.dart';
import 'package:flutter/material.dart';

class DrawerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(// tira o espaço no top do menu lateral
      child: Drawer(// menu lateral
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Marcos Ferreira"),
              accountEmail: Text("mlorencinif@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqP85ZnOcRSCX3nlYdkCvSxhSuZs0bLt1He8EvGr5ne8c7mTqW"),
              ),
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
    Navigator.pop(context); //fecha o menu lateral
    push(context, LoginPage(), replace: true);//vai destruir a widget home e vai para a tela de login
  }
}
