import 'package:flutter/material.dart';
import 'package:masteringflutter/product.dart';

class CategoryPage extends StatelessWidget {
  final List<Product> products;
  const CategoryPage({Key key, @required this.products}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // body:ListView.builder(
      //   itemCount: categoryProducts.length,
      //   itemBuilder: (context,index) =>
      //     ListTile(title: Text(categoryProducts[index].name),),
      // )
      body:ListView(children: <Widget>[
        ...products.map((p)=>ListTile(title: Text(p.name),))
      ],)
    );
  }
}