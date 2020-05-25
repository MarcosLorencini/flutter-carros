

import 'package:flutter/material.dart';

import 'carro.dart';
import 'carros_api.dart';

class CarrosListView extends StatefulWidget { //converteu para Statetul  para salvar o status das abas só realiza a requisicao 1x
  String tipo;
  CarrosListView(this.tipo);

  @override
  _CarrosListViewState createState() => _CarrosListViewState();
}

class _CarrosListViewState extends State<CarrosListView> with AutomaticKeepAliveClientMixin<CarrosListView> { //para salvar o status das abas só realiza a requisicao 1x
  @override
  bool get wantKeepAlive => true; //para salvar o status das abas só realiza a requisicao 1x

  @override
  Widget build(BuildContext context) {
    super.build(context); //para salvar o status das abas só realiza a requisicao 1x
    return _body();
  }

  _body() {
    Future<List<Carro>> carros = CarrosApi.getCarros(widget.tipo);

    return FutureBuilder( //é um widget que fica aguardando o Future retornar(ele converte um Future em um Widget), pois o Future não é um widget
      future: carros, //carros é o Future que o FutureBuilder tem que agurdar
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasError) {// caso gere um erro no retorno da api
          return Center(
            child: Text(
              "Não foi possível buscar os carros",
              style: TextStyle(
                color: Colors.red,
                fontSize: 22,
              ),
            ),
          );
        }
        if(! snapshot.hasData) {// na 1x vai estar vazio ai mostra o icone circular
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
                          onPressed: () {
                            /* ... */
                          },
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
}
