import 'package:carros/drawer_list.dart';
import 'package:carros/pages/carros/carro_form_page.dart';
import 'package:carros/pages/carros/carros_api.dart';
import 'package:carros/pages/carros/carros_page.dart';
import 'package:carros/pages/favoritos/favoritos_page.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/utils/prefs.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  //converteu para Statetul  para salvar o status das abas só realiza a requisicao 1x
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin<HomePage> { //para salvar o status das abas só realiza a requisicao 1x

  TabController _tabController; //monitorar as abas para que quando renderizar a tela mostrar a aba escolhida

  @override
  void initState()  {// NÃO SE USA O await e o async DENTRO DO initState
    super.initState();

    _initTabs();
  }

  _initTabs() async {

    // Primeiro busca o índice nas prefs.
    int tabIdx = await Prefs.getInt("tabIdx");//devolve um dado future de inteiro que como é assincrono(Future) pode demorar, na 1x é nulo

    // Depois cria o TabController
    // No método build na primeira vez ele poderá estar nulo
    _tabController = TabController(length: 4, vsync: this); // length: 4 quantidade da aba é o proprio SingleTickerProviderStateMixin mante o estado da aba escolhida

    // Agora que temos o TabController e o índice da tab,
    // chama o setState para redesenhar a tela
    setState(() {
      _tabController.index = tabIdx; //le o valor do indice salvo e mostra a tab do indice que foi acessada pela última vez, no 1 acesso é zero

    });

    _tabController.addListener(() { //monitora as abas
      Prefs.setInt("tabIdx", _tabController.index); //salva o indice da Tab que foi selecionada pela última vez internamente
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Carros"),
        ),
        bottom: _tabController == null//pq na 1x pode ser nulo e não chama o build 2x
            ? null
            : TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: "Clássicos",
              icon: Icon(Icons.directions_car),
            ),
            Tab(
              text: "Esportivos",
              icon: Icon(Icons.directions_car),
            ),
            Tab(
              text: "Luxo",
              icon: Icon(Icons.directions_car),
            ),
            Tab(
              text: "Favoritos",
              icon: Icon(Icons.favorite),
            )
          ],
        ),
      ),
      body: _tabController == null
          ? Center(
        child: CircularProgressIndicator(),
            )
          :  TabBarView(
        controller: _tabController,
        children: [
          CarrosPage(TipoCarro.classicos),
          CarrosPage(TipoCarro.esportivos),
          CarrosPage(TipoCarro.luxo),
          FavoritosPage(),
        ],
      ),
      drawer: DrawerList(), //menu lateral
      floatingActionButton: FloatingActionButton(//botão de add
        child: Icon(Icons.add),
        onPressed: _onClickAdicionarCarro,
      ),
    );
  }

  void _onClickAdicionarCarro() {
    push(context, CarroFormPage());//vai para tela de form para criar um carro
  }
}
