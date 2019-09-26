import 'package:flutter/material.dart';
import 'package:masteringflutter/category.dart';
import 'package:masteringflutter/categorypage.dart';

class HomePage extends StatefulWidget {
  final CategoriesBloc bloc = CategoriesBloc();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E-Commerce"),
      ),
      body: StreamBuilder<List<Category>>(
        stream: widget.bloc.categories,
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
        },)
    );
  }
}