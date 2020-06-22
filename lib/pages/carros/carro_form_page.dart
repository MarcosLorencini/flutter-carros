import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carros_api.dart';
import 'package:carros/utils/alert.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/widgets/app_button.dart';
import 'package:carros/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CarroFormPage extends StatefulWidget {
  final Carro carro;

  CarroFormPage(
      {this.carro}); //entre chaves é opcional, pois da home page vem vazio pq vai add um carro. Do carro_page.dart vem preenchido pois vai editar um carro

  @override
  State<StatefulWidget> createState() => _CarroFormPageState();
}

class _CarroFormPageState extends State<CarroFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final tNome = TextEditingController();
  final tDesc = TextEditingController();
  final tTipo = TextEditingController();

  int _radioIndex = 0;

  var _showProgress = false;

  File _file;

  Carro get carro => widget.carro;

  // Add validate email function.
  String _validateNome(String value) {
    if (value.isEmpty) {
      return 'Informe o nome do carro.';
    }

    return null;
  }

  @override
  void initState() { //inicia os dados da tela ou logica de inicialização da tela
    super.initState();

    // Copia os dados do carro para o form
    if (carro != null) {
      tNome.text = carro.nome;
      tDesc.text = carro.descricao;
      _radioIndex = getTipoInt(carro); //seta o radio button correspondente ao tipo de carro
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          carro != null
              ? carro.nome
              : "Novo Carro", //se for cadastrar um novo carro mostra Novo Carro
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16), // padding ao redor do fom 16 é pradrão
        child: _form(),
      ),
    );
  }

  _form() {
    return Form(
      key: this._formKey, //serve para validar os campos do form quando clicar em salvar
      child: ListView( //faz um scroll na tela se nescessario
        children: <Widget>[
          _headerFoto(),
          Text(
            "Clique na imagem para tirar uma foto",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Divider(),
          Text(
            "Tipo",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
          _radioTipo(),
          Divider(),
          AppText(
            "Nome",
            "",
            contoller: tNome,
            keyboardType: TextInputType.text,
            validator: _validateNome,
          ),
          AppText(
            "Descrição",
            "",
            contoller: tDesc,
            keyboardType: TextInputType.text,
            validator: _validateNome,
          ),
          AppButton(
            "Salvar",
            onPressed: _onClickSalvar,
            showProgress: _showProgress, //mostra a animação ou não
          )
        ],
      ),
    );
  }

  _headerFoto() {
    return InkWell(  //efeito da foto na figura
      onTap: _onClickFoto,
      child: _file != null //mostra afoto da camera
          ? Image.file(
              _file,
              height: 150,
            )
          : carro != null//ou mostra a foto do carro ou uma imagem de camera
              ? CachedNetworkImage(
                  imageUrl: carro.urlFoto,
                  height: 150,
                )
              : Image.asset(
                  "assets/images/camera.png",
                  height: 150,
                ),
    );
  }

  _radioTipo() {
    return Row(  //fica um widget ao lado do outro
      mainAxisAlignment: MainAxisAlignment.center, //os radios ficam no centro não precisa usar o widget Center
      children: <Widget>[
        Radio(
          value: 0,
          groupValue:
              _radioIndex, //sempre que esta variável for igual ao  value: 0 fica selecionado
          onChanged: _onClickTipo,
        ),
        Text(
          "Clássicos",
          style: TextStyle(color: Colors.blue, fontSize: 15),
        ),
        Radio(
          value: 1,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          "Esportivos",
          style: TextStyle(color: Colors.blue, fontSize: 15),
        ),
        Radio(
          value: 2,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          "Luxo",
          style: TextStyle(color: Colors.blue, fontSize: 15),
        ),
      ],
    );
  }

  void _onClickTipo(int value) {  //aqui pode chegar o valor 0 ou 1 ou 2
    setState(() { //redezenha a tela como o radio button setado que foi escolhido
      _radioIndex = value;
    });
  }

  getTipoInt(Carro carro) {
    switch (carro.tipo) {
      case "classicos":
        return 0;
      case "esportivos":
        return 1;
      default:
        return 2;
    }
  }

  String _getTipo() {
    switch (_radioIndex) {
      case 0:
        return "classicos";
      case 1:
        return "esportivos";
      default:
        return "luxo";
    }
  }

  void _onClickFoto() async {
    File file = await ImagePicker.pickImage(source: ImageSource.camera); //pega a foto tirada da camera
    if (file != null) {
      setState(() {   //redezenha a tela e joga a foto na variavel tipo File
        this._file = file;
      });
    }
  }

  _onClickSalvar() async {
    if (!_formKey.currentState.validate()) {  //quando clicar em salvar vai chamar todos os validators do form
      return;
    }

    // Cria o carro
    var c = carro ?? Carro(); //se carro for dif de null pega o carro ao contrario cria um novo carro
    c.nome = tNome.text;
    c.descricao = tDesc.text;
    c.tipo = _getTipo();

    print("Carro: $c");

    setState(() {  //redezenha a tela e motra a circle no botão
      _showProgress = true;
    });

    print("Salvar o carro $c");

    ApiResponse<bool> response = await CarrosApi.save(c, _file);  //so quem for adm pode salvar um carro e envia a foto tirada para ser salva pela api
    if (response.ok) {
      alert(context, "Carro salvo com sucesso", callback: () { // callback: () chama a funcao de callback
        pop(context); //retona para a tela anterior após salvar o carro
      });
    } else {
      alert(context, response.msg);
    }

    //await Future.delayed(Duration(seconds: 3));

    setState(() { //redezenha a tela e para de mostrar o circle no botão
      _showProgress = false;
    });

    print("Fim.");
  }
}
