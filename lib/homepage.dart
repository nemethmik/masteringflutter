import 'package:flutter/material.dart';
import 'package:masteringflutter/blocprovider.dart';
import 'package:masteringflutter/category.dart';
import 'package:masteringflutter/categorypage.dart';
import 'package:masteringflutter/product.dart';
//import 'package:masteringflutter/dbapi.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CategoriesBloc bloc = BlocProvider.of(context);
    print("**** Bloc Type is ${bloc.runtimeType.toString()}");
    return Scaffold(
      appBar: AppBar(
        title: Text("E-Commerce"),
      ),
      body: StreamBuilder<List<Category>>(
        stream: bloc.categories,
        builder: (context,snapshot){
          if(snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context,index){
                try {return 
                  ListTile(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CategoryPage(
                        products: [
                          Product.fromJson('{"id":"01","name":"Spion","amount":10}'),
                          Product.fromJson('{"id":"02","name":"Xenon","amount":324}'),
                        ],
                      ))),
                    title: Text(snapshot.data[index].name,
                        style: TextStyle(fontSize: 24.0),
                      ),
                  );
                } catch(_){ return null;}
            },);
          } else return Center(child: CircularProgressIndicator(),);
        },)
    );
  }
}