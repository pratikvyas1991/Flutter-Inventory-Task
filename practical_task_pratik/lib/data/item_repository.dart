import 'package:practicaltaskpratik/data/item_dao.dart';
import 'package:practicaltaskpratik/data/api_result_model.dart';

class ItemRepository {
  final itemDao = ItemDao();

  Future getItems({String query}) => itemDao.getItems();
//
//  Future getItem(int id) => itemDao.getItem(c_id: id);

  Future createItem(Items item) => itemDao.createItem(item);

  Future updateItem(Items item) => itemDao.updateItem(item);

  Future deleteItem(int id) => itemDao.deleteItem(id);

  Future getRooms() => itemDao.getRoomName();

  Future getSearchedRooms(roomName) => itemDao.getSearchedRoomName(roomName);


  Future getItemsOfRoom(String room_id) => itemDao.getRomItems(room_id);

  Future getSearchItemsOfRoom(String room_id,String searchkey) => itemDao.getSearchedRomItems(room_id,searchkey);

  Future getSavedItems() => itemDao.getSavedItems();

  Future getSelectedSavedItems() => itemDao.getSelectedSavedItems();

  Future getItemsWeb() => itemDao.getItemsWeb();

}