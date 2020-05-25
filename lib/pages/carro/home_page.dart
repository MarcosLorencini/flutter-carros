import 'package:carros/drawer_list.dart';
import 'package:carros/pages/carro/carro.dart';
import 'package:carros/pages/carro/carros_api.dart';
import 'package:carros/pages/carro/carros_listView.dart';
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
    _tabController = TabController(length: 3, vsync: this); // length: 3 quantidade da aba é o proprio SingleTickerProviderStateMixin mante o estado da aba escolhida

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
            ),
            Tab(
              text: "Esportivos",
            ),
            Tab(
              text: "Luxo",
            ),
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
          CarrosListView(TipoCarro.classicos),
          CarrosListView(TipoCarro.esportivos),
          CarrosListView(TipoCarro.luxo)
        ],
      ),
      drawer: DrawerList(), //menu lateral
    );
  }
}
