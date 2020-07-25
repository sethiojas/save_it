import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:save_it/src/models/Items.dart';

abstract class DB {
  static Database _db;
  static int get _version => 1;
  static String table = 'items';

  static Future<void> init() async {
    if (_db != null) return;
    try {
      String _path = join(await getDatabasesPath(), 'saveIt.db');
      _db = await openDatabase(_path, version: _version, onCreate: _onCreate);
    } catch (exception) {
      print(exception);
    }
  }

  static void _onCreate(Database db, int version) async => await db.execute(
      'CREATE TABLE items (id INTEGER PRIMARY KEY, name STRING, amount DOUBLE, transactions TEXT, amount_saved DOUBLE)');

  static Future<List<Items>> query() async {
    var response = await _db.query(table);
    List<Items> itemList =
        response.map((elem) => Items.fromMap(elem)).toList() ?? [];
    return itemList;
  }

  static Future<int> insert(Items obj) async =>
      await _db.insert(table, obj.toMap());

  static Future<int> update(Items obj) async => await _db.update(
        table,
        obj.toMap(),
        where: 'id = ?',
        whereArgs: [obj.id],
      );

  static Future<int> delete(Items obj) async => await _db.delete(
        table,
        where: 'id = ?',
        whereArgs: [obj.id],
      );
}
