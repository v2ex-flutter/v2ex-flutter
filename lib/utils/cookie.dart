import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class Cookie {
  static Cookie _cookie;
  Database _database;
  Map<String, bool> _tableExistState = {};
  static Cookie shareInstance() {
    if (null == _cookie) {
      _cookie = new Cookie();
      print('init');
    }
    return _cookie;
  }

  void _setCookie(String host, String key, String value) async {
    if (null == _tableExistState[host] || !_tableExistState[host]) {
      print('create table');
      await _database.execute(
          "CREATE TABLE IF NOT EXISTS $host (id TEXT PRIMARY KEY, value TEXT)");
      _tableExistState[host] = true;
      print(_tableExistState[host]);
    }

    await _database.execute(
        "INSERT OR REPLACE INTO $host (id, value) VALUES('$key', '$value')");
  }

  void setCookie(String host, String key, String value) async {
    if (null == _database) {
      String path =
          (await getApplicationDocumentsDirectory()).path + '/cookie.db';
      _database =
          await openDatabase(path, version: 1, onOpen: (Database db) async {
        _setCookie(host, key, value);
      });
    } else {
      _setCookie(host, key, value);
    }
  }

  Future<List<Map<String, dynamic>>> getCookie(String host) async {
    List<Map<String, dynamic>> ret =
        await _database.rawQuery("SELECT * FROM $host");
    return ret;
  }
}
