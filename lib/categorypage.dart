import 'package:flutter/material.dart';
import 'package:masteringflutter/category.dart';
import 'package:masteringflutter/product.dart';

//The only reason to make this class stateful is to be able to dispose
//Each time category page is created a special products bloc is created for that category
//and when the page is closed, the bloc is disposed, too.
//This is enough reason to use the provider package, see the next version.
class CategoryPage extends StatefulWidget {
  final Category category;
  const CategoryPage(this.category,{Key key,}) : super(key: key);
  @override
  _CategoryPageState createState() => _CategoryPageState();
}
class _CategoryPageState extends State<CategoryPage> {
  ProductsBloc bloc;
  @override void dispose() {
    bloc?.dispose(); // If bloc is not null dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    bloc ??= ProductsBloc(widget.category); // If bloc is null, initialize it
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<List<Product>>(
        stream: bloc.products,
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