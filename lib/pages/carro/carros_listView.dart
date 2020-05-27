

import 'dart:async';

import 'package:carros/pages/carro/carro_page.dart';
import 'package:carros/pages/carro/carros_bloc.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/widgets/text_error.dart';
import 'package:flutter/material.dart';

import 'carro.dart';

class CarrosListView extends StatefulWidget { //converteu para Statetul  para salvar o status das abas só realiza a requisicao 1x
  String tipo;
  CarrosListView(this.tipo);

  @override
  _CarrosListViewState createState() => _CarrosListViewState();
}

class _CarrosListViewState extends State<CarrosListView> with AutomaticKeepAliveClientMixin<CarrosListView> { //para salvar o status das abas só realiza a requisicao 1x

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
          return _listView(carros);
      },
    );
  }

  Container _listView(List<Carro> carros) {
    return Container(
      //precisou pq o Card estava muito na borda da esquerda, pois o Container é usado para trabalhar com propriedade do css
      padding: EdgeInsets.all(16), //epassamento externo da card
      child: ListView.builder(
          itemCount: carros != null ? carros.length : 0, //quando acessou o FutureBuilder na 1x o snapshot.data estava vazio, passando null para o metdodo Container _listView(List<Carro> carros)
          itemBuilder: (context, index) {
            Carro c = carros[index];

            return Card(
              color: Colors.grey[100],
              child: Container(
                padding: EdgeInsets.all(10), //epacamento interno  do card
                child: Column(
                  //coloca uma lista abaixo da outra
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //joga tudo para esquerda
                  children: <Widget>[
                    Center(
                      child: Image.network(
                        // centraliza a imagem dos carros
                        c.urlFoto != null ? c.urlFoto : "http://www.livroandroid.com.br/livro/carros/luxo/Mercedes_McLaren.png",
                        width: 250,
                      ),
                    ),
                    Text(
                      c.nome !=null ? c.nome : "Descrição Mercedes SLR McLaren",
                      maxLines: 1,
                      // fica um linha
                      overflow: TextOverflow.ellipsis,
                      // deixa 3 pontinhos quando o texto é grande
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      "descrição...",
                      style: TextStyle(fontSize: 16),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('DETALHES'),
                          onPressed: () => _onClickCarro(c),
                        ),
                        FlatButton(
                          child: const Text('SHARE'),
                          onPressed: () {
                            /* ... */
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  _onClickCarro(Carro c) {
    push(context, CarroPage(c));
  }

  void dispose() {
    super.dispose();
    _bloc.dispose();
  }


}
