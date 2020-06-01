import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/favoritos/favorito.dart';
import 'package:carros/pages/favoritos/favorito_dao.dart';

class FavoritoService {

  static favoritar(Carro c) {

    Favorito f = Favorito.fromCarro(c);//copia id e nome do carro para id e nome favorito

    final dao = FavoritoDAO();

    dao.save(f);
  }
}