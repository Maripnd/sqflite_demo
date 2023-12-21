import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_demo/models/product.dart';

class DbHelper
{

  late Database _db;

  Future<Database> get db async
  {
    if (db==null)
      {
        _db = await initializeDb();
      }
    return _db;
  }

  Future<Database> initializeDb() async
  {
    String dbPath = join( await getDatabasesPath(), "extrade.db");
    var eTradeDb = await openDatabase(dbPath,version: 1,onCreate: createDb);
    return eTradeDb;
  }

  void createDb(Database db, int version) async
  {
    await db.execute("CREATE TABLE products(id INTEGER PRIMARY KEY, name TEXT, description TEXT, unitPrice INTEGER)");
  }

  Future<List<Product>> getProducts() async
  {
    Database db = await this.db;
    var result = await db.query("products");
    return List.generate(result.length, (i)
    {
      return Product.fromObject(result[i]);
    });
  }

  FutureOr<int> insert(Product product) async {
      Database db = await this.db;
      var result = await db.insert("products", product.toMap());
      return result;
  }
  Future<int> delete(int id) async
  {

    Database db = await this.db;

    var result = await db.rawDelete("delete from products where id= $id");
    return result;

  }
  Future<int> update(Product product) async
  {

    Database db = await this.db;

    var result = await db.update("products" ,product.toMap(), where: "id=?",whereArgs:[product.id]);
    return result;

  }
}