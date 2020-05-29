

import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carro_page.dart';
import 'package:carros/utils/nav.dart';
import 'package:flutter/material.dart';



//CLASSE QUE MOSTRA A LISTA OS CARROS

class CarrosListView extends StatelessWidget { //converteu para Statetul  para salvar o status das abas só realiza a requisicao 1x
 List<Carro> carros;


 CarrosListView(this.carros);//receb a lista de carros do carros_page.dart

 @override
  Widget build(BuildContext context) {
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
                          onPressed: () => _onClickCarro(context, c),
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

  _onClickCarro(context, Carro c) {
    push(context, CarroPage(c));
  }


}
