import 'package:flutter/material.dart';
// import 'package:masteringflutter/category.dart';
import 'package:masteringflutter/product.dart';
import 'blocprovider.dart';
class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // body:ListView.builder(
      //   itemCount: categoryProducts.length,
      //   itemBuilder: (context,index) =>
      //     ListTile(title: Text(categoryProducts[index].name),),
      // )
      // body:ListView(children: <Widget>[
      //   ...products.map((p)=>ListTile(title: Text(p.name),))
      // ],)
      body: StreamBuilder<List<Product>>(
        stream: BlocProvider.of<ProductsBloc>(context).products,
        builder: (context,snapshot){
          if(snapshot.hasData) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: snapshot.data.length,
              itemBuilder: (context,index) =>
                ListTile(title: Text(snapshot.data[index].name),),
            );  
          } else return Center(child: CircularProgressIndicator(),);
        },)
    );
  }
}