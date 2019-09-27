import 'package:flutter/material.dart';
import 'package:masteringflutter/category.dart';
import 'package:masteringflutter/categorypage.dart';
import 'disposable.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("E-Commerce"),
        ),
        body: DisposableStream<CategoriesBloc,List<Category>>(
          value: CategoriesBloc(),
          stream: (bloc) => bloc.categories,
          builder: (context,snapshot){
            if(snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (context,index){
                  try {
                    return 
                    ListTile(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CategoryPage(snapshot.data[index]),
                        )),
                      title: Text(snapshot.data[index].name,
                          style: TextStyle(fontSize: 24.0),
                        ),
                    );
                  } catch(_){ return null;}
              },);
            } else return Center(child: CircularProgressIndicator(),);
          },),
    );
  }
}