import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practicaltaskpratik/bloc/item_bloc.dart';
import 'package:practicaltaskpratik/data/item_repository.dart';
import 'package:practicaltaskpratik/ui/dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
//      home: Dashboard(),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ItemBloc>(
            builder: (context) => ItemBloc(repository: ItemRepository()),
          ),
          BlocProvider<RoomItemBloc>(
            builder: (context) => RoomItemBloc(repository: ItemRepository()),
          ),
          BlocProvider<CarttemBloc>(
            builder: (context) => CarttemBloc(repository: ItemRepository()),
          ),
        ],
        child: Dashboard(),
      ),
    );
  }
}
