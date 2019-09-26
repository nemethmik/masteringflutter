import 'package:flutter/material.dart';
import 'package:masteringflutter/category.dart';
import 'package:masteringflutter/product.dart';
//import 'package:provider/provider.dart';

import 'disposable.dart';

class CategoryPage extends StatelessWidget {
  final Category category;
  const CategoryPage(this.category,{Key key,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: DisposableStream<ProductsBloc,List<Product>>(
          value: ProductsBloc(category),
          stream: (bloc) => bloc.products,
          builder: (context,snapshot){
            if(snapshot.hasData) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount:  snapshot.data.length,
                itemBuilder: (context,index) =>
                  ListTile(title: Text(snapshot.data[index].name),),
              );  
            } else return Center(child: CircularProgressIndicator(),);
          },
        ),
      );
  }
}