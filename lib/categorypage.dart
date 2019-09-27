import 'package:flutter/material.dart';
import 'package:masteringflutter/category.dart';
import 'package:masteringflutter/product.dart';
import 'package:provider/provider.dart';
//import 'package:provider/provider.dart';

import 'cart.dart';
import 'cartbutton.dart';
import 'disposable.dart';

class CategoryPage extends StatelessWidget {
  final Category category;
  const CategoryPage(this.category,{Key key,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartBloc>(context);
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[CartButton()],
        ),
        body: DisposableStream<ProductsBloc,List<Product>>(
          value: ProductsBloc(category),
          stream: (bloc) => bloc.products,
          builder: (context,snapshot){
            if(snapshot.hasData) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount:  snapshot.data.length,
                itemBuilder: (context,index) => Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.network(snapshot.data[index].imageUrl,fit: BoxFit.cover,),
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: (){cart.addProduct(snapshot.data[index]);},
                          child: Center(child: Text(snapshot.data[index].name)),),
                      ),
                    ),
                  ],
                )
//                  ListTile(title: Text(snapshot.data[index].name),),
              );  
            } else return Center(child: CircularProgressIndicator(),);
          },
        ),
      );
  }
}