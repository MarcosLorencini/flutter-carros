import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//onde a pasta do arquivo fica dentro do xiaomi:
//abra: Device File Explorer
//fica em data/data/com.lorencini.marcos.carros/databases/carros.db
//copia o carros.db para o computador e abra C:\Program Files\DB Browser for SQLite/DB Browser for SQLite.exe
//com.lorencini.marcos.carros é o applicationId do projeto

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.getInstance(); //chama ele para criar uma estancia de db 1x é um singleton que controla o bd
  DatabaseHelper.getInstance();//namedCostructor chama o construtor abaixo

  factory DatabaseHelper() => _instance;//factory é um construtor tbm um if podendo criar um novo objeto ou retornar um estancia de cache que já foi criada

  static Database _db;

  Future<Database> get db async {//a 1x que chamar o db o mesmo vai estar nulo e chama o metodo  _initDb() para criar o bd
    if (_db != null) {
      return _db;
    }
    _db = await _initDb();//1x chama este método para criar o banco de dados

    return _db;
  }

  Future _initDb() async {
    String databasesPath = await getDatabasesPath();//pega o caminho do banco de dados ex: data/data/com.lorencini.marcos.carros/databases/
    String path = join(databasesPath, 'carros.db');//ai cria este arquivo carros.db la no sqlflite
    print("db $path");//imprime o caminho do banco

    var db = await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);//abre o banco de dados
    return db;
  }

  void _onCreate(Database db, int newVersion) async {//cria a tabela somente 1x quando o banco de dados ainda não existe
    await db.execute(
        'CREATE TABLE carro(id INTEGER PRIMARY KEY, tipo TEXT, nome TEXT'
            ', descricao TEXT, urlFoto TEXT, urlVideo TEXT, latitude TEXT, longitude TEXT)');
  }

  //caso precise atualizar a tabela por exemplo com uma nova coluna altera o campo version: do método openDatabase
  Future<FutureOr<void>> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("_onUpgrade: oldVersion: $oldVersion > newVersion: $newVersion");

    //se a versão antiga for 1 e a nova versao for 2 add a NOVA coluna do tipo TEXT
    if(oldVersion == 1 && newVersion == 2) {
      await db.execute("alter table carro add column NOVA TEXT");
    }
  }
  //se não fechar não tem problema
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}