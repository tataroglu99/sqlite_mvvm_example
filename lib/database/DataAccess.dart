import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_mvvm_example/model/UnitModel.dart';
import 'package:sqlite_mvvm_example/utility/Utils.dart';
import '../model/UserModel.dart';

class DataAccess {
  static final DataAccess instance = DataAccess.internal();
  factory DataAccess() => instance;

  static Database? _db;

  Future<Database> get db async =>
      _db ??= await initDb();

  initDb() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = p.join(documentsDirectory.path, "dbUserInfo.db");
      var theDb = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE User ("
            "id INTEGER PRIMARY KEY,"
            "identityNumber INTEGER,"
            "nameSurname TEXT,"
            "phone TEXT,"
            "eMail TEXT,"
            "isDeleted BIT"
            ")");

        await db.execute("CREATE TABLE Unit ("
            "id INTEGER PRIMARY KEY,"
            "name TEXT"
            ")");
        //await db.execute("INSERT INTO Unit (name) VALUES ('Unit-1'), ('Unit-2'), ('Unit-3'),  ('Unit-4');");
      },
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
          if (oldVersion == 2) {

            await db.execute("CREATE TABLE Unit ("
                "id INTEGER PRIMARY KEY,"
                "name TEXT"
                ")");
            //await db.execute("INSERT INTO Unit (name) VALUES ('Unit-1'), ('Unit-2'), ('Unit-3'),  ('Unit-4');");
          }},
      );

      return theDb;
    }
    on Exception catch (ex)
    {
      return null;
    }


  }

  DataAccess.internal();

  //User Area
  Future<UserModel> insert(UserModel userModel) async {
    var dbClient = await db;
    //get the biggest id in the table
    var table = await dbClient.rawQuery("SELECT MAX(id)+1 as id FROM $UserTable");
    Object? id = table.first["id"];
    if(id != null){
      userModel.id = id as int;
    }
    else {
      userModel.id = 1;
    }
    userModel.id = await dbClient.insert(UserTable, userModel.toMap());
    return userModel;
  }

  Future<UserModel?> getUserModel(int id) async {
    final dbClient = await db;
    var res = await dbClient.query(UserTable, where: "$UserId = ?", whereArgs: [id]);
    return res.isNotEmpty ? UserModel.fromMap(res.first) : null;
  }

  Future<int> deleteUserModel(int id) async {
    var dbClient = await db;
    return await dbClient.delete(UserTable, where: '$UserId = ?', whereArgs: [id]);
  }

  Future<int> setDeletedTrue(UserModel userModel) async {
    var dbClient = await db;
    userModel.isDeleted = true;
    var res = await dbClient.update(UserTable, userModel.toMap(),
        where: "$UserId = ?", whereArgs: [userModel.id]);
    return res;
  }

  Future<int> updateUserModel(UserModel userModel) async {
    var dbClient = await db;
    return await dbClient.update(UserTable, userModel.toMap(),
        where: '$UserId = ?', whereArgs: [userModel.id]);
  }

  Future<List<UserModel>> getAllUsers() async {
    var dbClient = await db;
    var res = await dbClient.query(UserTable);
    List<UserModel> list =
    res.isNotEmpty ? res.map((c) => UserModel.fromMap(c)).toList() : [];
    if(list.isNotEmpty) {
      list.sort((a, b) => a.nameSurname.compareTo(b.nameSurname));
    }
    return list;
  }

  Future<List<UserModel>> getAllActiveUsers() async {
    var dbClient = await db;
    var res = await dbClient.query(UserTable, where: "$UserIsDeleted = 1" );
    var resUnit = await dbClient.query("Unit");
    List<UserModel> list =
    res.isNotEmpty ? res.map((c) => UserModel.fromMap(c)).toList() : [];
    if(list.isNotEmpty) {
      list.sort((a, b) => a.nameSurname.compareTo(b.nameSurname));
    }
    return list;
  }

  //Unit Area
  Future<UnitModel> insertUnit(UnitModel unitModel) async {
    var dbClient = await db;
    //get the biggest id in the table
    var table = await dbClient.rawQuery("SELECT MAX(id)+1 as id FROM $UnitTable");
    Object? id = table.first["id"];
    if(id != null){
      unitModel.id = id as int;
    }
    else {
      unitModel.id = 1;
    }

    unitModel.name = "${unitModel.name} - $id";
    unitModel.id = await dbClient.insert(UnitTable, unitModel.toMap());
    return unitModel;
  }

  Future<UnitModel?> getUnitModel(int id) async {
    final dbClient = await db;
    var res = await dbClient.query(UnitTable, where: "$UnitId = ?", whereArgs: [id]);
    return res.isNotEmpty ? UnitModel.fromMap(res.first) : null;
  }

  Future<int> deleteUnitModel(int id) async {
    var dbClient = await db;
    return await dbClient.delete(UnitTable, where: '$UnitId = ?', whereArgs: [id]);
  }

  Future<int> updateUnitModel(UnitModel unitModel) async {
    var dbClient = await db;
    return await dbClient.update(UnitTable, unitModel.toMap(),
        where: '$UnitId = ?', whereArgs: [unitModel.id]);
  }

  Future<List<UnitModel>> getAllUnitModels() async {
    var dbClient = await db;
    var res = await dbClient.query(UnitTable);
    List<UnitModel> list =
    res.isNotEmpty ? res.map((c) => UnitModel.fromMap(c)).toList() : [];
    if(list.isNotEmpty) {
      list.sort((a, b) => a.name.compareTo(b.name));
    }
    return list;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
