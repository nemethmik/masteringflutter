import 'package:flutter/material.dart';
import 'package:masteringflutter/cartpage.dart';
import 'package:provider/provider.dart';

import 'cart.dart';

class CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<CartBloc>(context);
    return Stack(
      children: <Widget>[
        IconButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context)=>CartPage()));
          },
          icon: Icon(Icons.shopping_cart),),
        Positioned(top:5,right: 5,child:CircleAvatar(
          radius: 8,backgroundColor: Colors.red,
          child: StreamBuilder<int>(
            stream: bloc.count,
            initialData: 0,
            builder: (context,snapshot)=>Text(
              snapshot.data.toString(),
              style: TextStyle(fontSize: 12.0),
            ),),
        ))
      ],
      
    );
  }
}