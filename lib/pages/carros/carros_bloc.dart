import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carros_api.dart';
import 'package:carros/pages/carros/simple_bloc.dart';


//o bloc contem a logica
class CarrosBloc extends SimpleBloc<List<Carro>> {

  Future<List<Carro>> loadCarros(String tipo) async {
    try {
      List<Carro> carros = await CarrosApi.getCarros(tipo);

      add(carros); //publica na lista de carros na stream

      return carros;//retorna a lista de carros para o RefreshIndicator na classe carros_page.dart

    }catch (e) {
      addError(e);//precisa tratar para cair no StreamBuilder do carros_listView.dart
    }

  }


}