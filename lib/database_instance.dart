import 'package:minggu_03/history_list.dart';
import 'package:minggu_03/shopping_list.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBhelper {
  Database? _database;
  final String _table_name = 'shopping_list';
  final String _table_name_2 = 'history_list';
  final String _db_name = 'shoppinglist_database.dart';
  final int _db_version = 1;

  DBhelper() {
    _openDB();
  }

  Future<void> _openDB() async {
    _database ??= await openDatabase(
      join(await getDatabasesPath(), _db_name),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE $_table_name (id INTEGER PRIMARY KEY, name TEXT, sum INTEGER)'
        );
        await db.execute(
          'CREATE TABLE $_table_name_2 (id INTEGER PRIMARY KEY, name TEXT, sum INTEGER, dateTime TEXT)'
        );
      },
      version: _db_version
    );
  }

  Future<void> insertShoppingList(ShoppingList tmp) async {
    await _database?.insert(
      _table_name, 
      tmp.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<void> insertHistoryList(HistoryList tmp) async {
    await _database?.insert(
      _table_name_2, 
      tmp.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<ShoppingList>> getMyShoppingList() async {
    if(_database != null) {
      final List<Map<String, dynamic>> maps = await _database!.query(_table_name);
      print('Isi DB' + maps.toString());
      return List.generate(
        maps.length, 
        (i) {
          return ShoppingList(maps[i]['id'], maps[i]['name'], maps[i]['sum']);
        }
      );
    }
    return [];
  }

  Future<List<HistoryList>> getMyHistoryList() async {
    if(_database != null) {
      final List<Map<String, dynamic>> maps = await _database!.query(_table_name_2);
      return List.generate(
        maps.length, 
        (i) {
          return HistoryList(maps[i]['id'], maps[i]['name'], maps[i]['sum'], DateTime.parse(maps[i]['dateTime']));
        }
      );
    }
    return [];
  }

  Future<void> deleteShoppingList(int id) async {
    await _database?.delete(
      _table_name,
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future<void> closeDB() async {
    await _database?.close();
  }

  Future<void> deleteAllShoppingList() async {
    await _database?.delete(_table_name);
  }
}
