import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carros_api.dart';
import 'package:carros/pages/carros/simple_bloc.dart';
import 'package:carros/pages/carros/carro_dao.dart';
import 'package:carros/pages/favoritos/favorito_service.dart';
import 'package:carros/utils/network.dart';


//o bloc contem a logica
class FavoritosBloc extends SimpleBloc<List<Carro>> {

  Future<List<Carro>> fetch() async {
    try {

      List<Carro> carros = await FavoritoService.getCarros();//pega os carros favoritados da API
/*
      if(carros.isNotEmpty) {
        final dao = CarroDAO();
        carros.forEach(dao.save); //pega os carros favoritados da API e salva no sqlfite
      }*/

      add(carros); //publica na lista de carros favoritados na stream

      return carros;//retorna a lista de carros favoritados para o RefreshIndicator na classe favoritos_page.dart

    }catch (e) {
      addError(e);//precisa tratar para cair no StreamBuilder do favoritos_page.dart
    }

  }


}