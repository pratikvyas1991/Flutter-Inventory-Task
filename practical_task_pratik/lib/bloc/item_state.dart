import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:practicaltaskpratik/data/api_result_model.dart';

abstract class ItemState extends Equatable {}
abstract class RoomItemState extends Equatable {}
abstract class CartItemState extends Equatable {}

class ItemInitialState extends ItemState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ItemLoadingState extends ItemState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ItemLoadedState extends ItemState {

  List<Items> items;

  ItemLoadedState({@required this.items});

  @override
  // TODO: implement props
  List<Object> get props => [items];
}

class ItemErrorState extends ItemState {

  String message;

  ItemErrorState({@required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}

// Room Items States :

class RoomItemInitialState extends RoomItemState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class RoomItemLoadingState extends RoomItemState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class RoomItemLoadedState extends RoomItemState {

  List<Items> items;

  RoomItemLoadedState({@required this.items});

  @override
  // TODO: implement props
  List<Object> get props => [items];
}

class RoomItemErrorState extends RoomItemState {

  String message;

  RoomItemErrorState({@required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}

// Cart Items States :

class CarttemInitialState extends CartItemState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CarttemLoadingState extends CartItemState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CarttemLoadedState extends CartItemState {

  List<Items> items;

  CarttemLoadedState({@required this.items});

  @override
  // TODO: implement props
  List<Object> get props => [items];
}

class CartTabLoadedState extends CartItemState {

  List<Items> items;

  CartTabLoadedState({@required this.items});

  @override
  // TODO: implement props
  List<Object> get props => [items];
}

class CartLocaltemLoadedState extends CartItemState {

  List<Items> items;

  CartLocaltemLoadedState({@required this.items});

  @override
  // TODO: implement props
  List<Object> get props => [items];
}

class CarttemErrorState extends CartItemState {

  String message;

  CarttemErrorState({@required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}

