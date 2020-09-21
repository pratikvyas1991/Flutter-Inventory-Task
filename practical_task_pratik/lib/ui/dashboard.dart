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
import 'dart:io';

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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
    itemBloc = BlocProvider.of<ItemBloc>(context);
    roomItemBloc = BlocProvider.of<RoomItemBloc>(context);
    carttemBloc = BlocProvider.of<CarttemBloc>(context);
    itemBloc.add(FetchItemsEvent());
    carttemBloc.add(UpdateRoomItemsEvent());
    checkConnection();
  }

  checkConnection() async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//        showSnackBar(Strings.ConnectedToInternet);
        itemBloc.add(FetchItemsFromWebEvent());
        carttemBloc.add(UpdateRoomItemsEvent());
      }else{
        showSnackBar(Strings.NotConnectedToInternet);
        print('@@@ Calling from DB ');
        itemBloc.add(FetchItemsEvent());
        carttemBloc.add(UpdateRoomItemsEvent());
      }
    } on SocketException catch (_) {
      showSnackBar(Strings.NotConnectedToInternet);
    }
  }

  showSnackBar(String message){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(Strings.InternetConnectivity),
            content: Column(
              children: [
                Text(message),
                RaisedButton(
                  child: Text(Strings.Continue),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    print("@@@ build() FetchItemsEvent");
    return Material(
      child: Scaffold(
        key: _scaffoldKey,
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
                             getSelectedTab(),
                             getCartHeader(),
                             Divider(
                               color: Colors.black26,
                             ),
//                             getSavedItemListWidgetLocal(),
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
                return LoadingDialogue(" Cart ");
              } else if (state is CarttemLoadingState) {
                return LoadingDialogue(" Cart ");
              } else if (state is CarttemLoadedState) {
                return EditItemList(state.items);
//                if (state.items.length <= 0) {
//                  carttemBloc.add(UpdateRoomItemsEvent());
//                  return LoadingDialogue();
//                } else {
//                  return EditItemList(state.items);
//                }
              }else if (state is CartTabLoadedState) {
                return EditItemList(state.items);
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
            return LoadingDialogue(" Item ");
          } else if (state is RoomItemLoadingState) {
            return LoadingDialogue(" Item ");
          } else if (state is RoomItemLoadedState) {
            if (state.items == null || state.items.length <= 0) {
              roomItemBloc.add(FetchRoomItemsEvent(defaultRoomId));
              return LoadingDialogue(" Item ");
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
            return LoadingDialogue(" Room ");
          } else if (state is ItemLoadingState) {
            return LoadingDialogue(" Room ");
          } else if (state is ItemLoadedState) {
            if (state.items != null && state.items.length <= 0) {
              print("@@@ build() FetchItemsFromWebEvent");
              itemBloc.add(FetchItemsFromWebEvent());
              return LoadingDialogue(" Room ");
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
              setState(() {
                defaultRoomId = items[pos].roomid;
                isFirstTime = true;
              });
              roomItemBloc.add(FetchRoomItemsEvent(items[pos].roomid));
              carttemBloc.add(UpdateRoomItemsEvent());
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
                          setState(() {
                            isFirstTime = true;
                          });
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
              setState(() {
                tempList.add(items[pos]);
                isFirstTime = true;
              });
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

  Widget getSelectedTab() {
    return Container(
        margin: EdgeInsets.all(10),
        height: 40,
        child: BlocListener<CarttemBloc, CartItemState>(
          listener: (context, state) {
            if (state is ItemErrorState) {
              print("Error State");
            }
          },
          child: BlocBuilder<CarttemBloc, CartItemState>(
            builder: (context, state) {
              if (state is CarttemInitialState) {
                return LoadingDialogue(" Tab ");
              } else if (state is CarttemLoadingState) {
                return LoadingDialogue(" Tab ");
              } else if (state is CartTabLoadedState) {
                return getTabs(state.items);
              }else if (state is CarttemLoadedState) {
                if(isFirstTime){
                  isFirstTime = false;
                  return getTabs(state.items);
                }
              } else if (state is CarttemErrorState) {
                return ErrorDialogue(state.message);
              }
            },
          ),
        ));
  }

  Widget getTabs(List<Items> items) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemBuilder: (context, pos) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: getChips(items[pos]),
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
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
          setState(() {
            isFirstTime = true;
          });
        },
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
      ),
    );
  }

  Widget getChips(Items item) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 0.0),
      child: RaisedButton(
        color: item.isItemSelected?Colors.teal:Colors.grey,
        child: Text(item.roomname),
        onPressed: () {
          carttemBloc.add(CartTabEvent(item.roomid));
          setState(() {
            if(item.isItemSelected){
              item.isItemSelected = false;
            }else{
              item.isItemSelected = true;
            }
          });

        },
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
      ),
    );
  }
}
