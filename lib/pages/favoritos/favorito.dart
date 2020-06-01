
import 'package:carros/pages/carros/carro.dart';
import 'package:carros/utils/sql/entity.dart';

class Favorito extends Entity {

  int id;
  String nome;

  Favorito.fromCarro(Carro c) { //copia id e nome do carro para id e nome favorito
    id = c.id;
    nome = c.nome;
    print(">>>>>>>nome: $nome");
    print(">>>>>>>id: $id");
  }

  //faz o parse do map para um objeto é quando se está lendo o retorno do banco de dados
  Favorito.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
  }

  //converte um objeto para Map quando quer gravar é um banco de deados ou em uma sherefpresses
  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    return data;
  }



}