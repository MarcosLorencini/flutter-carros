

import 'dart:async';

class SimpleBloc<T> {


  final _controller = StreamController<T>();// recebe uma lista de carros

  Stream<T> get stream => _controller.stream;//o bloc está expondo a stream que o widget pode ficar ouvindo

  void add(T object) {
    _controller.add(object);
  }

  void addError(Object error) {
    if(! _controller.isClosed) {
      _controller.addError(error);
    }
  }

  void dispose() {
    _controller.close();//fecha a stream que é o fluxo de dados
  }


}