import 'package:carros/pages/carro/carro.dart';
import 'package:carros/pages/carro/carros_api.dart';
import 'package:carros/pages/carro/simple_bloc.dart';


//o bloc contem a logica
class CarrosBloc extends SimpleBloc<List<Carro>> {

  loadCarros(String tipo) async {
    try {
      List<Carro> carros = await CarrosApi.getCarros(tipo);

      add(carros); //recebe uma lista de carros
    }catch (e) {
      addError(e);//precisa tratar para cair no StreamBuilder do carros_listView.dart
    }

  }


}