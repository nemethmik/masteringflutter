import 'package:flutter/material.dart';
import 'package:masteringflutter/blocprovider.dart';
import 'package:masteringflutter/category.dart';
import 'package:masteringflutter/dbapi.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CategoriesBloc bloc = BlocProvider.of(context);
    print("**** Bloc Type is ${bloc.runtimeType.toString()}");
    return Scaffold(
      appBar: AppBar(
        title: Text("E-Commerce"),
      ),
      body: ListView.builder(
        //itemCount: dbApi.getCategories().length,
        itemBuilder: (context,index){
          // return index < dbApi.getCategories().length
          //   ? Text(dbApi.getCategories()[index].name)
          //   : null;
          try {return 
            Text(DbApi.me.getCategories()[index].name,
              style: TextStyle(fontSize: 24.0),
            );
          } catch(_){ return null;}
      },)
    );
  }
}