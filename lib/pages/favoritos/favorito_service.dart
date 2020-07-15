
import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carro_dao.dart';
import 'package:carros/pages/favoritos/favorito.dart';
import 'package:carros/pages/favoritos/favorito_dao.dart';
import 'package:provider/provider.dart';

import 'favoritos_bloc.dart';

class FavoritoService {

  static Future<bool> favoritar(context, Carro c) async {

    Favorito f = Favorito.fromCarro(c);//copia id e nome do carro para id e nome favorito

    final dao = FavoritoDAO();

    final exists  = await dao.exists(c.id);
      print(">>>>exists $exists");
    if(exists){
      //Remove dos favoritos
      dao.delete(c.id);

      FavoritosBloc favoritosBloc = Provider.of<FavoritosBloc>(context);// pegando o FavoritosBloc do Provider da main.dart
      favoritosBloc.fetch();//como o favoritosBloc está local vai atualizar a lista de favoritos na pagina

      return false;//volta o coracao para cinza
    } else {
      //Adiciona nos favoritos
      dao.save(f);

      FavoritosBloc favoritosBloc = Provider.of<FavoritosBloc>(context);// pegando o FavoritosBloc do Provider da main.dart
      favoritosBloc.fetch();//como o favoritosBloc está local vai atualizar a lista de favoritos na pagina

      return true;// deixa o coracao vermelho
    }
  }

  static Future<List<Carro>> getCarros() async {
    List<Carro> carros = await CarroDAO().query("SELECT * FROM carro c, favorito f WHERE c.id = f.id");
    return carros;
  }

  //verifica se o carro está favorito para deixa o coração vermelho ou não quando entrar nos detalhes do carro
  static Future<bool> isFavorito(Carro c) async {
    final dao = FavoritoDAO();
    bool exists  = await dao.exists(c.id);
    return exists;
  }
}