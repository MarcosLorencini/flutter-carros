import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carros_api.dart';
import 'package:carros/pages/carros/simple_bloc.dart';
import 'package:carros/pages/carros/carro_dao.dart';
import 'package:carros/utils/network.dart';


//o bloc contem a logica
class CarrosBloc extends SimpleBloc<List<Carro>> {

  Future<List<Carro>> loadCarros(String tipo) async {
    try {

      bool networkOn = await isNetworkOn();//verifica se possui internet
      //se não tiver internet retorna os carros do banco de dados ao contrario bate na api
       if(! networkOn) {
         List<Carro> carros =  await CarroDAO().findAllByTipo(tipo);//pega do bd
         add(carros); //publica na lista de carros na stream
         return carros;
       }
      List<Carro> carros = await CarrosApi.getCarros(tipo);//pega da API

      if(carros.isNotEmpty) {
        final dao = CarroDAO();
        carros.forEach(dao.save); //pega os carros da API e salva no sqlfite
      }

      add(carros); //publica na lista de carros na stream

      return carros;//retorna a lista de carros para o RefreshIndicator na classe carros_page.dart

    }catch (e) {
      addError(e);//precisa tratar para cair no StreamBuilder do carros_listView.dart
    }

  }


}