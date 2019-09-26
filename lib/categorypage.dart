import 'package:flutter/material.dart';
import 'package:masteringflutter/category.dart';
import 'package:masteringflutter/product.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatelessWidget {
  final Category category;
  const CategoryPage(this.category,{Key key,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Product>>(
      builder: (context) => ProductsBloc(category).products,
      //dispose: (context,bloc)=>bloc?.dispose(),
      child: Scaffold(
        appBar: AppBar(),
        body: Consumer<List<Product>>(
          builder: (context,products,child) {
              if(products != null) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemCount: products.length,
                  itemBuilder: (context,index) =>
                    ListTile(title: Text(products[index].name),),
                );  
              } else return Center(child: CircularProgressIndicator(),);
            },),
        ),
      );
  }
}