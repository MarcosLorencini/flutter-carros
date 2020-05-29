

import 'dart:async';

import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carros_bloc.dart';
import 'package:carros/pages/carros/carros_listView.dart';
import 'package:carros/widgets/text_error.dart';
import 'package:flutter/material.dart';



//CLASSE QUE BUSCA OS CARROS NA API
class CarrosPage extends StatefulWidget { //converteu para Statetul  para salvar o status das abas só realiza a requisicao 1x
  String tipo;
  CarrosPage(this.tipo);

  @override
  _CarrosPageState createState() => _CarrosPageState();
}

class _CarrosPageState extends State<CarrosPage> with AutomaticKeepAliveClientMixin<CarrosPage> { //para salvar o status das abas só realiza a requisicao 1x

  final _bloc  = CarrosBloc();

  @override
  bool get wantKeepAlive => true; //para salvar o status das abas só realiza a requisicao 1x

  @override
  void initState() {//é chamado uma unica vez na inicialização do StatefulWidget, pois a busca do getCarros ficar dentro dele
    super.initState();

    _bloc.loadCarros(widget.tipo);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); //para salvar o status das abas só realiza a requisicao 1x


    //programacao reativa usando streams observaveis, fica escutando as mudanças na stream:
    //na 1x vai ficar girando o CircularProgressIndicator
   return StreamBuilder(
        stream: _bloc.stream,//está na classe mae. Ouvi quando uma lista de carros é enviado para k  final _streamController = StreamController<List<Carro>>() na classe carros_bloc ; e renderiza somente o StreamBuilder
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            return TextError("Não foi possível buscar os carros");
          }
          if(!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(),);
          }
          List<Carro> carros = snapshot.data;// data dados do retorno do Future
          
          return RefreshIndicator(//gesto de put refres
            onRefresh: _onRefresh,
            child: CarrosListView(carros),
          );
      },
    );
  }


  Future<void> _onRefresh() {
    return _bloc.loadCarros(widget.tipo);
  }

  void dispose() {
    super.dispose();
    _bloc.dispose();
  }



}
