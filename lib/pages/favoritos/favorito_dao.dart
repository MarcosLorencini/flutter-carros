import 'package:carros/utils/sql/base_dao.dart';
import 'package:carros/pages/favoritos/favorito.dart';

class FavoritoDAO extends BaseDAO<Favorito> {
  @override
  Favorito fromMap(Map<String, dynamic> map) {
    return Favorito.fromMap(map);//lendo do banco parse do map para objeto
  }

  @override
  String get tableName => "favorito";

}