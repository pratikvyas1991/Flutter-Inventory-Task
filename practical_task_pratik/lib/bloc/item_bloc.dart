import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:practicaltaskpratik/bloc/item_state.dart';
import 'package:practicaltaskpratik/bloc/item_event.dart';
import 'package:practicaltaskpratik/data/api_result_model.dart';
import 'package:practicaltaskpratik/data/item_repository.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {

  ItemRepository repository;

  ItemBloc({@required this.repository});

  @override
  ItemState get initialState => ItemInitialState();

  @override
  Stream<ItemState> mapEventToState(ItemEvent event) async* {
    if (event is FetchItemsEvent) {
      yield ItemLoadingState();
      try {
        List<Items> itenms = await repository.getRooms();
        yield ItemLoadedState(items: itenms);
      } catch (e) {
        yield ItemErrorState(message: e.toString());
      }
    }else
    if (event is FetchSearchedItemsEvent) {
      yield ItemLoadingState();
      try {
        List<Items> itenms = await repository.getSearchedRooms(event.roomName);
        yield ItemLoadedState(items: itenms);
      } catch (e) {
        yield ItemErrorState(message: e.toString());
      }
    }
    else
    if (event is FetchItemsFromWebEvent) {
      yield ItemLoadingState();
      try {
        List<Items> itenms = await repository.getItemsWeb();
        yield ItemLoadedState(items: itenms);
      } catch (e) {
        yield ItemErrorState(message: e.toString());
      }
    }
    else
    if (event is UpdateRoomItemsEvent) {
      yield ItemLoadingState();
      try {
        List<Items> itenms = await repository.getItemsWeb();
        yield ItemLoadedState(items: itenms);
      } catch (e) {
        yield ItemErrorState(message: e.toString());
      }
    }

  }

}

class RoomItemBloc extends Bloc<RoomItemEvent, RoomItemState> {

  ItemRepository repository;

  RoomItemBloc({@required this.repository});

  @override
  RoomItemState get initialState => RoomItemInitialState();

  @override
  Stream<RoomItemState> mapEventToState(RoomItemEvent event) async* {

    if (event is FetchRoomItemsEvent) {
      yield RoomItemLoadingState();
      try {
        List<Items> itenms = await repository.getItemsOfRoom(event.roomId);
        yield RoomItemLoadedState(items: itenms);
      } catch (e) {
        yield RoomItemErrorState(message: e.toString());
      }
    }
    else
    if (event is FetchSearchedRoomItemsEvent) {
      yield RoomItemLoadingState();
      try {
        List<Items> itenms = await repository.getSearchItemsOfRoom(event.roomId,event.searchKey);
        yield RoomItemLoadedState(items: itenms);
      } catch (e) {
        yield RoomItemErrorState(message: e.toString());
      }
    }
  }

}

class CarttemBloc extends Bloc<CartItemEvent, CartItemState> {

  ItemRepository repository;

  CarttemBloc({@required this.repository});

  @override
  CartItemState get initialState => CarttemInitialState();

  @override
  Stream<CartItemState> mapEventToState(CartItemEvent event) async* {

    if (event is UpdateRoomItemsEvent) {
      yield CarttemLoadingState();
      try {
        List<Items> itenms = await repository.getSavedItems();
        yield CarttemLoadedState(items: itenms);
      } catch (e) {
        yield CarttemErrorState(message: e.toString());
      }
    }
    if (event is UpdateSelectedRoomItemsEvent) {
      yield CarttemLoadingState();
      try {
        List<Items> itenms = await repository.getSelectedSavedItems();
        yield CarttemLoadedState(items: itenms);
      } catch (e) {
        yield CarttemErrorState(message: e.toString());
      }
    }
    else
    if (event is UpdateQtyRoomItemsEvent) {
      yield CarttemLoadingState();
      try {
        List<Items> itenms = await repository.updateItem(event.items);
        yield CarttemLoadedState(items: itenms);
      } catch (e) {
        yield CarttemErrorState(message: e.toString());
      }
    }
  }

}