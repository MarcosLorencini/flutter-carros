

import 'dart:async';

import 'package:provider/provider.dart';

class Event {

}

class EventBus {
  static EventBus get(context) => Provider.of<EventBus>(context, listen: false);

  final _streamController = StreamController<Event>.broadcast();//por padrão esta stream só pode ser escutada uma x por isso o .broadcast()

  Stream<Event> get stream => _streamController.stream;

  //pulicar um evento no EventBus
  sendEvent(Event event) {
    _streamController.add(event);//recebe o event e public no EventBus
  }


  //toda vez que usa stream tem que fechá-la
  dispose() {
    _streamController.close();
  }


}