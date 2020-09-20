import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practicaltaskpratik/bloc/item_bloc.dart';
import 'package:practicaltaskpratik/bloc/item_event.dart';
import 'package:practicaltaskpratik/bloc/item_state.dart';
import 'package:practicaltaskpratik/data/api_result_model.dart';
import 'package:practicaltaskpratik/utility/error_dialogue.dart';
import 'package:practicaltaskpratik/utility/progress_loading_dialogue.dart';
import 'package:practicaltaskpratik/res/string_constants.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyHomePage();
  }
}

class MyHomePage extends State<Dashboard> {
  ItemBloc itemBloc;
  RoomItemBloc roomItemBloc;
  CarttemBloc carttemBloc;
  String defaultRoomId = "";
  final _formKey = GlobalKey<FormState>();
  List<Items> tempList = new List();
  @override
  void initState() {
    super.initState();
    itemBloc = BlocProvider.of<ItemBloc>(context);
    itemBloc.add(FetchItemsEvent());
    roomItemBloc = BlocProvider.of<RoomItemBloc>(context);
    carttemBloc = BlocProvider.of<CarttemBloc>(context);
    carttemBloc.add(UpdateRoomItemsEvent());

  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Inventory"),
        ),
       body:SingleChildScrollView(
         child: Stack(
           children: [
             Column(
               children: [
                 SizedBox(height: 10),
                 Row(
                   children: [
                     Column(
                       children: [
                         Container(
                           height: 40,
                           width: 270,
                           decoration: BoxDecoration(
                             border: Border.all(
                               color: Colors.grey,
                               width: 1,
                             ),
                             borderRadius: BorderRadius.circular(1),
                           ),
                           child: Center(
                             child: Text(Strings.Rooms,
                               textAlign: TextAlign.center,
                             ),
                           ),
                         ),
                         Container(
                             height: 50,
                             width: 270,
                           decoration: BoxDecoration(
                             color: Colors.white,
                             border: Border.all(
                               color: Colors.grey,
                               width: 1,
                             ),
                             borderRadius: BorderRadius.circular(1),
                           ),
                           child: TextFormField(
                             decoration: InputDecoration(
                                 prefixIcon:Icon(Icons.search),
                                 border: InputBorder.none, hintText: "Search"),
                             keyboardType: TextInputType.text,
                             validator: (value){
                               return '';
                             },
                             onChanged: (text){
                               if(text == ''|| text.length<0){
                                 itemBloc.add(FetchItemsEvent());
                               }else{
                                 itemBloc.add(FetchSearchedItemsEvent(text));
                               }

                             },
                           ),
                         ),
                         Container(
                           height: 400,
                           width: 290,
                           child: getRoomListWidget(),
                         )
                       ],
                     )
                    ,
                     SizedBox(height: 10),
                     Container(
                       height: 470,
                       width: 2,
                       color: Colors.grey,
                     ),
                     Column(
                       children: [
                         Container(
                           height: 40,
                           width: 270,
                           decoration: BoxDecoration(
                             border: Border.all(
                               color: Colors.grey,
                               width: 1,
                             ),
                             borderRadius: BorderRadius.circular(1),
                           ),
                           child: Center(
                             child: Text(Strings.Items,
                               textAlign: TextAlign.center,
                             ),
                           ),
                         ),
                         Container(
                           height: 50,
                           width: 270,
                           decoration: BoxDecoration(
                             color: Colors.white,
                             border: Border.all(
                               color: Colors.grey,
                               width: 1,
                             ),
                             borderRadius: BorderRadius.circular(1),
                           ),
                           child: TextFormField(
                             decoration: InputDecoration(
                                 prefixIcon:Icon(Icons.search),
                                 border: InputBorder.none, hintText: "Search"),
                             keyboardType: TextInputType.text,
                             validator: (value){
                               return '';
                             },
                             onChanged: (text){
                               if(text == ''|| text.length<0){
                                 roomItemBloc.add(FetchRoomItemsEvent(defaultRoomId));
                               }else{
                                 roomItemBloc.add(FetchSearchedRoomItemsEvent(defaultRoomId,text));
                               }
                             },
                           ),
                         ),
                         Container(
                           height: 400,
                           width: 290,
                           child: getRoomItemListWidget(),
                         )
                       ],
                     )

                   ],
                 ),
                 Container(
                     color: Color(0xFFE3F2FD),
                     height: 350,
                     width: 600,
                     child: Container(
                       margin: EdgeInsets.all(20),
                       color: Colors.white,
                       child: Form(
                         key: _formKey,
                         child: Column(
                           children: [
                             getTabs(),
                             getCartHeader(),
                             Divider(
                               color: Colors.black26,
                             ),
                             getSavedItemListWidget(),
                             getSaveButton()
                           ],
                         ),
                       ),

                     ))
               ],
             )
           ],
         ),
       ) ,
      ),
    );
  }

  Widget getSavedItemListWidget() {
    return Container(
        margin: EdgeInsets.all(10),
        height: 100,
        child: BlocListener<CarttemBloc, CartItemState>(
          listener: (context, state) {
            if (state is ItemErrorState) {
              print("Error State");
            }
          },
          child: BlocBuilder<CarttemBloc, CartItemState>(
            builder: (context, state) {
              if (state is CarttemInitialState) {
                return LoadingDialogue();
              } else if (state is CarttemLoadingState) {
                return LoadingDialogue();
              } else if (state is CarttemLoadedState) {
                if (state.items.length <= 0) {
                  carttemBloc.add(UpdateRoomItemsEvent());
                  return LoadingDialogue();
                } else {
                  return EditItemList(state.items);
                }
              } else if (state is CarttemErrorState) {
                return ErrorDialogue(state.message);
              }
            },
          ),
        ));
  }

  Widget getRoomItemListWidget() {
    return Container(
        child: BlocListener<RoomItemBloc, RoomItemState>(
      listener: (context, state) {
        if (state is ItemErrorState) {
          print("Error State");
        }
      },
      child: BlocBuilder<RoomItemBloc, RoomItemState>(
        builder: (context, state) {
          if (state is RoomItemInitialState) {
            return LoadingDialogue();
          } else if (state is RoomItemLoadingState) {
            return LoadingDialogue();
          } else if (state is RoomItemLoadedState) {
            if (state.items == null || state.items.length <= 0) {
              roomItemBloc.add(FetchRoomItemsEvent(defaultRoomId));
              return LoadingDialogue();
            } else {
              return buildItemList(state.items);
            }
          } else if (state is RoomItemErrorState) {
            return ErrorDialogue(state.message);
          } else {
            return ErrorDialogue("Other Error");
          }
        },
      ),
    ));
  }

  Widget getRoomListWidget() {
    return Container(
      height: 450,
        width: 250,
        child: BlocListener<ItemBloc, ItemState>(
      listener: (context, state) {
        if (state is ItemErrorState) {
          print("Error State");
        }
      },
      child: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state is ItemInitialState) {
            return LoadingDialogue();
          } else if (state is ItemLoadingState) {
            return LoadingDialogue();
          } else if (state is ItemLoadedState) {
            if (state.items != null && state.items.length <= 0) {
              itemBloc.add(FetchItemsFromWebEvent());
              return LoadingDialogue();
            } else {
              return buildRoomList(state.items);
            }
          } else if (state is ItemErrorState) {
            return ErrorDialogue(state.message);
          }
        },
      ),
    )
    );
  }

  Widget buildRoomList(List<Items> items) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, pos) {
        if (pos == 0) {
          roomItemBloc.add(FetchRoomItemsEvent(items[pos].roomid));
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: ListTile(
              title: Text(items[pos].roomname),
            ),
            onTap: () {
              print("@@@ Pressed with value : " + items[pos].roomname);
              setState(() {
                defaultRoomId = items[pos].roomid;
              });
              roomItemBloc.add(FetchRoomItemsEvent(items[pos].roomid));
            },
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  Widget EditItemList(List<Items> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (ctx, pos) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 30,
                      width: 110,
                      child: Text(
                        items[pos].cFieldName,
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 100,
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: items[pos].qty),
                        keyboardType: TextInputType.number,
                        validator: (value){
                          return items[pos].qty;
                        },
                        onChanged: (text){
                          if(isNumeric(text)){
                            setState(() {
                              items[pos].qty = text;
                              if(tempList.length>0){
                                tempList.forEach((element) {
                                  if((element.roomid == items[pos].roomid)){
                                    tempList.add(items[pos]);
                                  }
                                });
                              }else{
                                tempList.add(items[pos]);
                              }
                            });
                          }
                        },
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 120,
                      child: Text(items[pos].cWeight),
                    ),
                    Container(
                      height: 30,
                      width: 110,
                      child: Text((double.parse(items[pos].cWeight) *
                          double.parse(items[pos].qty))
                          .toString()),
                    ),
                    Container(
                      height: 30,
                      width: 80,
                      child: IconButton(
                        icon: Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            items[pos].qty = (0).toString();
                          });
                          carttemBloc.add(UpdateQtyRoomItemsEvent(items[pos]));
                          carttemBloc.add(UpdateRoomItemsEvent());
                          roomItemBloc
                              .add(FetchRoomItemsEvent(items[pos].roomid));
                        },
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Color(0xFFBDBDBD),
                )
              ],
            ),
            onTap: () {
//              navigateToArticleDetailPage(context, articles[pos]);
            },
          ),
        );
      },
    );
  }
  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  Widget buildItemList(List<Items> items) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, pos) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: int.parse((items[pos].qty)) > 0
                ? WidgetSelectedTile(items[pos])
                : WidgetUnSelectedTile(items[pos]),
            onTap: () {
              var qty = int.parse((items[pos].qty));
              if (qty == 0) {
                items[pos].qty = (qty + 1).toString();
              }
              print("@@@ Pressed with Field Name : " + items[pos].cFieldName);
              carttemBloc.add(UpdateQtyRoomItemsEvent(items[pos]));
              carttemBloc.add(UpdateRoomItemsEvent());
              roomItemBloc.add(FetchRoomItemsEvent(items[pos].roomid));
            },
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  WidgetSelectedTile(Items item) {
    return Container(
      color: Color(0xFFEEEEEE),
      child: ListTile(
        title: Text(item.cFieldName),
      ),
    );
  }

  WidgetUnSelectedTile(Items item) {
    return Container(
      child: ListTile(
        title: Text(item.cFieldName),
      ),
    );
  }

  Widget getTabs() {
    return Container(
      margin: EdgeInsets.all(5),
      color: Colors.white,
      child: Row(
        children: [getChips()],
      ),
    );
  }

  Widget getCartHeader() {
    return Container(
      margin: EdgeInsets.all(5),
      color: Color(0xFFE0E0E0),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 30,
                  width: 110,
                  child: Text(Strings.Item,),
                ),
                Container(
                  height: 30,
                  width: 110,
                  child: Text(Strings.Quantity),
                ),
                Container(
                  height: 30,
                  width: 110,
                  child: Text(Strings.Weight),
                ),
                Container(
                  height: 30,
                  width: 110,
                  child: Text(Strings.CalculatedLBS),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getSaveButton() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 0.0),
      child: RaisedButton(
        color: Colors.green,
        child: Text("Save"),
        onPressed: () {
          if(tempList!=null && tempList.length>0){
            tempList.forEach((element) {
              carttemBloc.add(UpdateQtyRoomItemsEvent(element));
              carttemBloc.add(UpdateRoomItemsEvent());
            });
          }

        },
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
      ),
    );
  }

  Map<Y, List<T>> groupBy<T, Y>(Iterable<T> itr, Y Function(T) fn) {
    return Map.fromIterable(itr.map(fn).toSet(),
        value: (i) => itr.where((v) => fn(v) == i).toList());
  }



  Widget getChips() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 0.0),
      child: RaisedButton(
        color: Colors.teal,
        child: Text("All Items"),
        onPressed: () {
//          if(tempList!=null && tempList.length>0){
//            tempList.forEach((element) {
//              carttemBloc.add(UpdateQtyRoomItemsEvent(element));
//              carttemBloc.add(UpdateRoomItemsEvent());
//            });
//          }
          var newMap = groupBy(tempList, (v) => v.length);
          print(newMap);

        },
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
      ),
    );
  }
}
