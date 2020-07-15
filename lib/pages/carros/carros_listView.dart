

import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carro_page.dart';
import 'package:carros/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share/share.dart';



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

            return InkWell(
              onTap: () => _onClickCarro(context, c),
              onLongPress: () => _onLongClickCarro(context, c),
              child: Card(
                color: Colors.grey[150],
                child: Container(
                  padding: EdgeInsets.all(10), //epacamento interno  do card
                  child: Column(
                    //coloca uma lista abaixo da outra
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //joga tudo para esquerda
                    children: <Widget>[
                      Center(  // centraliza a imagem dos carros
                        child: CachedNetworkImage( //ele cria um aquivo de cache na mesma pasta do bd carros de cache das imagens na prox vez é mais rápido
                          imageUrl: c.urlFoto != null ? c.urlFoto : "http://www.livroandroid.com.br/livro/carros/luxo/Mercedes_McLaren.png",
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
                              _onClickShare(context, c);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  _onClickCarro(context, Carro c) {
    push(context, CarroPage(c));
  }

  _onLongClickCarro(BuildContext context, Carro c) {
    showDialog(context: context, builder: (context){
      return SimpleDialog(
        title: Text(c.nome),
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text("Detalhes"),
            onTap: () {
              pop(context);
              _onClickCarro(context, c);
            },
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text("Share"),
            onTap: () {
              pop(context);
              _onClickShare(context, c);
            },
          )
        ],
      );
    });
  }

  void _onClickShare(BuildContext context, Carro c) {
    print("Share ${c.nome}");
    Share.share(c.urlFoto);
  }


}
