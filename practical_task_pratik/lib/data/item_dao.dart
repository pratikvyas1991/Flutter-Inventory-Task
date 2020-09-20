import 'dart:ffi';

import 'package:practicaltaskpratik/data/database.dart';
import 'package:practicaltaskpratik/res/string_constants.dart';
import 'package:practicaltaskpratik/data/api_result_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ItemDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<List<Items>> getItemsWeb() async {
    var response = await http.get(Strings.itemsUrl);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<Itemslist> itemList = ApiResultModel.fromJson(data).data.itemslist;
      for (var i in itemList) {
        List<Items> items = i.items;
        for(var itemCat in items){
          createItem(itemCat);
        }
      }
      var listFromDb = getRoomName();
      return listFromDb;
    } else {
      throw Exception();
    }
  }


  Future<List<Items>> getItems({List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null && query != '') {
      if (query.isNotEmpty) {
        result = await db.query(table_name,
            columns: columns, where: 'room_name LIKE ?', whereArgs: ['%$query%']);
      }
    } else {
      result = await db.query(table_name, columns: columns);
    }

    List<Items> users = result.isNotEmpty
        ? result.map((item) => Items.fromJson1(item)).toList()
        : [];
    return users;
  }

  Future<List<Items>> getRoomName() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result;
    result = await db.rawQuery(''
        'SELECT * FROM Items GROUP BY Items.room_id');
    List<Items> items = result.isNotEmpty
        ? result.map((item) => Items.fromJson1(item)).toList()
        : [];
    return items;
  }

  Future<List<Items>> getSearchedRoomName(String searchkey) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result;
    String query = "SELECT * FROM Items WHERE room_name LIKE '"+searchkey+"%' GROUP BY Items.room_id";
    result = await db.rawQuery(query);
    List<Items> items = result.isNotEmpty
        ? result.map((item) => Items.fromJson1(item)).toList()
        : [];
    return items;
  }

  Future<Void> getAllItems() async {
    final db = await dbProvider.database;

//    List<Map> list = await db.rawQuery(''
//        'SELECT Items.room_name,Items.room_id FROM Items GROUP BY Items.room_id');
    List<Map> list = await db.rawQuery(''
        'SELECT * FROM Items ');

    print(list);
//    print(expectedList);
  }

  Future<List<Items>> getRomItems(String room_id) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result;
    result = await db.rawQuery(''
        'SELECT * FROM Items WHERE Items.room_id = '+room_id);
    List<Items> items = result.isNotEmpty
        ? result.map((item) => Items.fromJson1(item)).toList()
        : [];
    return items;
  }

  Future<List<Items>> getSearchedRomItems(String room_id,String searchkey) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result;
    String query = "SELECT * FROM Items WHERE room_name LIKE '"+searchkey+"%' AND Items.room_id = "+room_id+" GROUP BY Items.room_id";
    result = await db.rawQuery(query);
    List<Items> items = result.isNotEmpty
        ? result.map((item) => Items.fromJson1(item)).toList()
        : [];
    return items;
  }

  Future<List<Items>> getSavedItems() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result;
    result = await db.rawQuery(''
        'SELECT * FROM Items WHERE Items.qty > 0');
    print(result);
    List<Items> items = result.isNotEmpty
        ? result.map((item) => Items.fromJson1(item)).toList()
        : [];
    return items;
  }

  Future<List<Items>> getSelectedSavedItems() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result;
    result = await db.rawQuery(''
        'SELECT * FROM Items WHERE Items.qty > 0 GROUP BY Items.room_id');
    print(result);
    List<Items> items = result.isNotEmpty
        ? result.map((item) => Items.fromJson1(item)).toList()
        : [];
    return items;
  }

  Future<int> createItem(Items item) async {
    final db = await dbProvider.database;

    var result = await db.insert(table_name, item.toJson());

    return result;
  }

  Future<int> updateItem(Items item) async {
    final db = await dbProvider.database;

    var result = await db.update(table_name, item.toJson(),
        where: 'c_id = ?', whereArgs: [item.cId]);

    return result;
  }

  Future<int> deleteItem(int c_id) async {
    final db = await dbProvider.database;

    var result = await db.delete(table_name, where: 'c_id = ?', whereArgs: [c_id]);

    return result;
  }
}