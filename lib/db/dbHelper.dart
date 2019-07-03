import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:etrade/models/product.dart';

class DbHelper {
  String tblProduct = "Products";
  String colId = "Id";
  String colName = "Name";
  String colDescription = "Description";
  String colPrice = "Price";
  // final kelimesi readonly yapar
  static final DbHelper _dbHelper = DbHelper._internal();

  // static olarak kodlama
  DbHelper._internal();

  // kullanıcı nesneyi çağırdığı zaman dbhelper dönecek
  factory DbHelper() {
    return _dbHelper;
  }

  static Database _db;

  // operasyon bittiğinde ne olacak
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    // veri tabanı yoksa
    _db = await initializeDb();
    return _db;
  }

  Future<Database> initializeDb() async {
    // klasörü getir
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "etrade.db";
    var dbEtrade = await openDatabase(path, version: 1, onCreate: _createDb);

    return dbEtrade;
  }

  // db oluştu tablolar ekle
  void _createDb(Database db, int version) async {
    await db.execute(
        "Create table $tblProduct ($colId INTEGER PRIMARY KEY, $colName text, " +
            "$colDescription text,$colPrice int)");
  }

  // product tablosu için insert
  Future<int> insert(Product product) async {
    Database db = await this.db;
    //var delete = await db.delete(tblProduct);
    var result = await db.insert(tblProduct, product.toMap());
    //var cc = await db.query("select * from $tblProduct order by $colName ASC");
    return result;
  }

  // product tablosu için update
  Future<int> update(Product product) async {
    Database db = await this.db;
    var result = await db.update(tblProduct, product.toMap(),
        where: "$colId =?", whereArgs: [product.id]);
    return result;
  }

  //product tablosu için delete
  Future<int> delete(int id) async {
    Database db = await this.db;
    var result =
        await db.rawDelete("Delete from $tblProduct where $colId = $id");
    return result;
  }

  // products tablosu için select metodu
  Future<List> getProducts() async {
    Database db = await this.db;
    var result = await db.rawQuery("Select * from $tblProduct");
    return result;
  }

  // product tablosu için where
  Future getWhereProduct(int id) async {
    Database db = await this.db;
    var result =
        await db.rawQuery("Select * from $tblProduct where $colId = $id");
    return result;
  }
}
