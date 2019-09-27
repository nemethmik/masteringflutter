import 'package:flutter/material.dart';
import 'package:masteringflutter/product.dart';
import 'package:provider/provider.dart';

import 'cart.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartBloc>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Cart"),),
      body: StreamBuilder<List<Product>>(
        stream: cart.products,
        initialData: [/*Product.fromJson('{"id":"01","name":"Zoom H1","amount":10}')*/],
        builder: (context, snapshot) {
          return snapshot.data.isNotEmpty
          ? ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context,index) => ListTile(
              title: Text(snapshot.data[index].name),
              trailing: Text(snapshot.data[index].amount.toString()),),
          )
          : Center(child: Text("Empty"),);
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.arrow_forward)
      ),
    );
  }
}