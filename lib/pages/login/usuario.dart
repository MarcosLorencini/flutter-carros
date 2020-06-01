import 'dart:convert' as convert;

import 'package:carros/utils/prefs.dart';

class Usuario {
  String login;
  String nome;
  String email;
  String urlFoto;
  String token;
  List<String> roles;

  Usuario(
      {this.login,
        this.nome,
        this.email,
        this.urlFoto,
        this.token,
        this.roles});

  Usuario.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    nome = json['nome'];
    email = json['email'];
    urlFoto = json['urlFoto'];
    token = json['token'];
    roles = json['roles'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.login;
    data['nome'] = this.nome;
    data['email'] = this.email;
    data['urlFoto'] = this.urlFoto;
    data['token'] = this.token;
    data['roles'] = this.roles;
    return data;
  }
  //limpa as prefs quando dlogout
  static void clear() {
    Prefs.setString("user.prefs", "");
  }

  //salva o usuario no Pefs
  void save() {
    //pega o usuario como map
    Map map = toJson();

    //converste para String
    String json = convert.json.encode(map);

    Prefs.setString("user.prefs", json);
  }

  //le o usuario que foi salvo no prefs
  static Future<Usuario> get() async {
    String json = await Prefs.getString("user.prefs");//recupera o use no prefs
    if(json.isEmpty) {
      return null;
    }
    Map map  = convert.json.decode(json); //convert para Map
    Usuario user = Usuario.fromJson(map); //e convert map para objeto
    return user;

  }

  @override
  String toString() {
    return 'Usuario{login: $login, nome: $nome}';
  }


}