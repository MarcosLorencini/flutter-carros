import 'dart:async';

import 'package:carros/utils/sql/db_helper.dart';
import 'package:carros/utils/sql/entity.dart';
import 'package:sqflite/sqflite.dart';

// Data Access Object
abstract class BaseDAO<T extends Entity> {
//db é o banco de dados
  Future<Database> get db => DatabaseHelper.getInstance().db;//pega esta variavel antes de usar os metodos

  String get tableName;//metodo abstrato

  T fromMap(Map<String, dynamic> map);

  //todos os metodos é usado o db que é o banco de dados sqlflite
  Future<int> save(T entity) async {
    var dbClient = await db;
    var id = await dbClient.insert(tableName, entity.toMap(),//nome da tabela + map json
    conflictAlgorithm: ConflictAlgorithm.replace);//se já existir os carros atualize se ouver alguma atualizacao
    print('id: $id');
    return id;
  }

  Future<List<T>> findAll() async {
    final dbClient = await db;
    final list = await dbClient.rawQuery('select * from $tableName');
    return list.map<T>((json) => fromMap(json)).toList();

  }

  Future<T> findById(int id) async {
    var dbClient = await db;
    final list =
    await dbClient.rawQuery('select * from $tableName where id = ?', [id]);
    if (list.length > 0) {
      return fromMap(list.first);
    }
    return null;
  }

  Future<bool> exists(int id) async {
    T c = await findById(id);
    var exists = c != null;
    return exists;
  }

  Future<int> count() async {
    final dbClient = await db;
    final list = await dbClient.rawQuery('select count(*) from $tableName');
    return Sqflite.firstIntValue(list);
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.rawDelete('delete from $tableName where id = ?', [id]);
  }

  Future<int> deleteAll() async {
    var dbClient = await db;
    return await dbClient.rawDelete('delete from $tableName');
  }
}