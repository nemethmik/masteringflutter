import 'package:flutter/material.dart';
import 'package:masteringflutter/category.dart';
import 'package:masteringflutter/categorypage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<CategoriesBloc>(
      builder: (context) => CategoriesBloc(),
      dispose: (context,bloc) => bloc?.dispose(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("E-Commerce"),
        ),
        body: Consumer<CategoriesBloc>(
          builder: (context,bloc,child) => StreamBuilder<List<Category>>(
            stream: bloc.categories,
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
        )
      ),
    );
  }
}