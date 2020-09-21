import 'package:practicaltaskpratik/res/string_constants.dart';

class ApiResultModel {
  String _code;
  String _status;
  Data _data;

  ApiResultModel({String code, String status, Data data}) {
    this._code = code;
    this._status = status;
    this._data = data;
  }

  String get code => _code;

  set code(String code) => _code = code;

  String get status => _status;

  set status(String status) => _status = status;

  Data get data => _data;

  set data(Data data) => _data = data;

  ApiResultModel.fromJson(Map<String, dynamic> json) {
    _code = json['code'];
    _status = json['status'];
    _data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this._code;
    data['status'] = this._status;
    if (this._data != null) {
      data['data'] = this._data.toJson();
    }
    return data;
  }
}

class Data {
  List<Itemslist> _itemslist;

  Data({List<Itemslist> itemslist}) {
    this._itemslist = itemslist;
  }

  List<Itemslist> get itemslist => _itemslist;

  set itemslist(List<Itemslist> itemslist) => _itemslist = itemslist;

  Data.fromJson(Map<String, dynamic> json) {
    if (json['itemslist'] != null) {
      _itemslist = new List<Itemslist>();
      json['itemslist'].forEach((v) {
        _itemslist.add(new Itemslist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._itemslist != null) {
      data['itemslist'] = this._itemslist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Itemslist {
  String _roomId;
  String _roomName;
  String _surveyId;
  List<Items> _items;

  Itemslist(
      {String roomId, String roomName, String surveyId, List<Items> items}) {
    this._roomId = roomId;
    this._roomName = roomName;
    this._surveyId = surveyId;
    this._items = items;
  }

  String get roomId => _roomId;

  set roomId(String roomId) => _roomId = roomId;

  String get roomName => _roomName;

  set roomName(String roomName) => _roomName = roomName;

  String get surveyId => _surveyId;

  set surveyId(String surveyId) => _surveyId = surveyId;

  List<Items> get items => _items;

  set items(List<Items> items) => _items = items;

  Itemslist.fromJson(Map<String, dynamic> json) {
    _roomId = json['room_id'];
    _roomName = json['room_name'];
    _surveyId = json['survey_id'];

    if (json['items'] != null) {
      _items = new List<Items>();
      json['items'].forEach((v) {

        _items.add(new Items.fromJson(v,_roomId,_roomName,"0"));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_id'] = this._roomId;
    data['room_name'] = this._roomName;
    data['survey_id'] = this._surveyId;
    if (this._items != null) {
      data['items'] = this._items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int _itemId;
  String _cId;
  String _cFieldName;
  String _cWeight;
  String _roomid;
  String _roomname;
  String _qty;
  bool _isTabSelected = false;
  bool _isItemSelected = false;

  Items(
      {
        int itemId,
        String cId,
      String cFieldName,
      String roomid,
      String roomname,
      String qty}) {
    this._itemId = itemId;
    this._cId = cId;
    this._cFieldName = cFieldName;
    this._cWeight = cWeight;
    this._roomid = roomid;
    this._roomname = roomname;
    this._qty = qty;
  }

  int get itemId => _itemId;

  set itemId(int itemId) => _itemId = itemId;

  bool get isTabSelected => _isTabSelected;

  set isTabSelected(bool isTabSelected) => _isTabSelected = isTabSelected;

  bool get isItemSelected => _isItemSelected;

  set isItemSelected(bool isItemSelected) => _isItemSelected = isItemSelected;


  String get qty => _qty;

  set qty(String qty) => _qty = qty;

  String get roomname => _roomname;

  set roomname(String roomname) => _roomname = roomname;

  String get roomid => _roomid;

  set roomid(String roomid) => _roomid = roomid;

  String get cId => _cId;

  set cId(String cId) => _cId = cId;

  String get cFieldName => _cFieldName;

  set cFieldName(String cFieldName) => _cFieldName = cFieldName;


  String get cWeight => _cWeight;

  set cWeight(String cWeight) => _cWeight = cWeight;


  Items.fromJson(Map<String, dynamic> json,String roomid,String roomname,String qty) {
    _itemId = json['item_id'];
    _cId = json['c_id'];
    _cFieldName = json['c_field_name'];
    _cWeight = json['c_weight'];
    _roomid = roomid ;
    _roomname = roomname ;
    _qty = qty ;
  }
  Items.fromJson1(Map<String, dynamic> json) {
    _itemId = json['item_id'];
    _cId = json['c_id'];
    _cFieldName = json['c_field_name'];
    _cWeight = json['c_weight'];
    _roomid = json['room_id'];;
    _roomname = json['room_name']; ;
    _qty = json['qty']; ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this._itemId;
    data['c_id'] = this._cId;
    data['c_field_name'] = this._cFieldName;
    data['c_weight'] = this._cWeight;
    data['room_id'] = this._roomid;
    data['room_name'] = this._roomname;
    data['qty'] = this._qty;
    return data;
  }
}
