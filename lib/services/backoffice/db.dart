import 'package:hive_flutter/adapters.dart';

class Database {
  static const databaseName = "macanacki";
  static const videoKey = "videos";
 
  static Future initDatabase() async {
    await Hive.initFlutter(databaseName);
  }

  static Future<Box<dynamic>> openDatabase() async {
    var db = await Hive.openBox(databaseName);
    return db;
  }

  static Future create(key, dynamic data) async {
    var db = await openDatabase();
    await db.put(key, data);

    
  }

  static Future read(key) async {
    var db = await openDatabase();
    var data = db.get(key);

    return data;
  }

  static Future update(key, dynamic data) async {
    var db = await openDatabase();
    await db.put(key, data);
  }

  static Future delete(key) async {
    var db = await openDatabase();
    await db.delete(key);
  }
}
