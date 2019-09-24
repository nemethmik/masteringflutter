import 'package:flutter/material.dart';
import 'package:masteringflutter/dbapi.dart';

class HomePage extends StatelessWidget {
  final dbApi = DbApi();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E-Commerce"),
      ),
      body: ListView.builder(
        //itemCount: dbApi.getCategories().length,
        itemBuilder: (context,index){
          return index < dbApi.getCategories().length
            ? Text(dbApi.getCategories()[index].name)
            : null;
      },)
    );
  }
}