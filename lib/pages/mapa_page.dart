import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'carros/carro.dart';

class MapaPage extends StatelessWidget {
  final Carro carro;
  MapaPage(this.carro);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(carro.nome),
      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
      child: GoogleMap(
       // mapType: MapType.satellite,//mostra a imagem do satelite
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
            target: latLng(),
            zoom: 17
        ),//objeto que recebe a ltd e lgt. onde o mapa vai abrir
      ),
    );
  }

  latLng() {
    return carro.latlng();
  }
}
