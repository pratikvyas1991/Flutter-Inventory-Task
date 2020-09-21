import 'package:equatable/equatable.dart';
import 'package:practicaltaskpratik/data/api_result_model.dart';

abstract class ItemEvent extends Equatable {}

abstract class RoomItemEvent extends Equatable {}

abstract class CartItemEvent extends Equatable {}

class FetchItemsEvent extends ItemEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class FetchSearchedItemsEvent extends ItemEvent {
  String roomName;

  FetchSearchedItemsEvent(this.roomName);

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class FetchItemsFromWebEvent extends ItemEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class FetchRoomItemsEvent extends RoomItemEvent {
  String roomId;

  FetchRoomItemsEvent(this.roomId);

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class FetchSearchedRoomItemsEvent extends RoomItemEvent {
  String roomId;
  String searchKey;

  FetchSearchedRoomItemsEvent(this.roomId, this.searchKey);

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class UpdateRoomItemsEvent extends CartItemEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class UpdateSelectedRoomItemsEvent extends CartItemEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class UpdateQtyRoomItemsEvent extends CartItemEvent {
  Items items;

  UpdateQtyRoomItemsEvent(this.items);

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LocalTempRoomItemsEvent extends CartItemEvent {
  List<Items> items;

  LocalTempRoomItemsEvent(this.items);

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class CartTabEvent extends CartItemEvent {
  String roomId;

  CartTabEvent(this.roomId);

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class StaticCartItemsEvent extends CartItemEvent {
  List<Items> items;

  StaticCartItemsEvent(this.items);

  @override
  // TODO: implement props
  List<Object> get props => null;
}
