import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/loripsum_api.dart';
import 'package:carros/widgets/text.dart';
import 'package:flutter/material.dart';

class CarroPage extends StatefulWidget {

  Carro carro;

  CarroPage(this.carro);

  @override
  _CarroPageState createState() => _CarroPageState();
}

class _CarroPageState extends State<CarroPage> {
  final _loripsumApiBloc = LoripsumBloc();

  @override
  void initState() {
    super.initState();
    _loripsumApiBloc.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.carro.nome),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.place),
            onPressed: _onClickMapa,
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: _onClickVideo,
          ),
          PopupMenuButton<String>(
            onSelected: (String value) => _onClickPopupMenu(value), //passa o value dos PopupMenuItem
            itemBuilder: (BuildContext context) { //3 pontinhos
              return [
                PopupMenuItem(
                  value: "Editar",
                  child: Text("Editar"),
                ),
                PopupMenuItem(
                  value: "Deletar",
                  child: Text("Deletar"),
                ),
                PopupMenuItem(
                  value: "Share",
                  child: Text("Share"),
                ),
              ];
            },
          )
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            Image.network(widget.carro.urlFoto),
            _bloco1(),
            Divider(),//cria a linha horizontal
            _bloco2(),
          ],
        )
    );
  }

  Row _bloco1() {
    return Row(//1 liha com 1 coluna e 2 linhas
            mainAxisAlignment: MainAxisAlignment.spaceBetween, //espaço entre a Column o Row
            children: <Widget>[
              Column(//coluna da ESQUERDA nome do carro e tipo
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  text(widget.carro.nome, fontSize: 20, bold: true),//text.dart
                  text(widget.carro.tipo, fontSize: 16)//text.dart
                ],
              ),
              Row(//2 linha(icones) o favorito e o shared (para o o favorito e o shared  ficaem um ao lado do outro )
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.favorite, color: Colors.red, size: 40,),
                    onPressed: _onClickFavorito,
                  ),
                  IconButton(
                    icon: Icon(Icons.share, size: 40,),
                    onPressed: _onClickShare,
                  ),

                ],

              )
            ],
          );
  }

  _bloco2() {
    return Column(//deixa um item abaixo do outro
      crossAxisAlignment: CrossAxisAlignment.start,//alinha para a esquerda
      children: <Widget>[
        SizedBox(height: 20,),//margin
        text(widget.carro.descricao, fontSize: 16, bold: true),
        SizedBox(height: 20,),//margin
        StreamBuilder<String>(
          stream: _loripsumApiBloc.stream,//fica ouvindo o acesso a api
          builder:(BuildContext context, AsyncSnapshot snapshot ) {
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(),);
            }
            return text(snapshot.data, fontSize: 16);
          },
        ),
      ],
    );
  }

  void _onClickMapa() {}

  void _onClickVideo() {}

  _onClickPopupMenu(String value) {
    switch (value) {
      case "Editar":
        print("Editar !!!");
        break;
      case "Deletar":
        print("Deletar !!!");
        break;
      case "Share":
        print("Share !!!");
        break;
    }
  }

  void _onClickFavorito() {
  }

  void _onClickShare() {
  }

  void dispose() {
    super.dispose();
    _loripsumApiBloc.dispose();
  }
}
