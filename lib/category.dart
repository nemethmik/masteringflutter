import 'dart:async';

import 'package:masteringflutter/blocprovider.dart';
import 'package:masteringflutter/dbapi.dart';

class Category {
  static const NAME = "name";
  String id;
  String name;
  Category.fromJson(Map<String,dynamic> jsonMap){
    name = jsonMap[NAME];
  }
}
class CategoriesBloc implements Disposable {
  List<Category> _categoryList;
  final _categoryListStream = StreamController<List<Category>>();
  Stream<List<Category>> get categories => _categoryListStream.stream;
  //It does't have to be async since the data are anyway returned in stream
  //which is anyway an async way of returning data.
  void getCategories(){
    _categoryList = DbApi.me.getCategories();
    _categoryListStream.add(_categoryList);
  }
  @override
  void dispose() {
    _categoryListStream.close();
  }
  CategoriesBloc() {
    getCategories();
  }
}