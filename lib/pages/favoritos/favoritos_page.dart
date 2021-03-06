import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carros_listView.dart';
import 'package:carros/pages/favoritos/favoritos_bloc.dart';
import 'package:carros/widgets/text_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



//CLASSE QUE BUSCA OS CARROS NA API
class FavoritosPage extends StatefulWidget { //converteu para Statetul  para salvar o status das abas só realiza a requisicao 1x
   @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> with AutomaticKeepAliveClientMixin<FavoritosPage> { //para salvar o status das abas só realiza a requisicao 1x


  @override
  bool get wantKeepAlive => true; //para salvar o status das abas só realiza a requisicao 1x. E para atualizar na tela tem que fazer o refresh com o dedo

  @override
  void initState() {//é chamado uma unica vez na inicialização do StatefulWidget, pois a busca do getCarros ficar dentro dele
    super.initState();

    FavoritosBloc favoritosBloc = Provider.of<FavoritosBloc>(context, listen: false);// pegando o FavoritosBloc do Provider da main.dart. listen: false não quer ficar ouvindo os dados do modelo
    favoritosBloc.fetch();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); //para salvar o status das abas só realiza a requisicao 1x

    FavoritosBloc favoritosBloc = Provider.of<FavoritosBloc>(context);// pegando o FavoritosBloc do Provider da main.dart
    //programacao reativa usando streams observaveis, fica escutando as mudanças na stream:
    //na 1x vai ficar girando o CircularProgressIndicator
   return StreamBuilder(
        stream: favoritosBloc.stream,//está na classe mae. Ouvi quando uma lista de carros favoritados é enviado para k  final _streamController = StreamController<List<Carro>>() na classe favoritos_bloc ; e renderiza somente o StreamBuilder
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            return TextError("Não foi possível buscar os favoritos");
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
    FavoritosBloc favoritosBloc = Provider.of<FavoritosBloc>(context);// pegando o FavoritosBloc do Provider da main.dart
    return favoritosBloc.fetch();
  }


}
