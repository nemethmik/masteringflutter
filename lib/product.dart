import 'dart:async';
import 'dart:convert';

import 'package:masteringflutter/category.dart';
import 'package:masteringflutter/dbapi.dart';

import 'disposable.dart';
class Product {
  static const NAME = "name";
  static const ID = "id";
  static const AMOUNT = "amount";
  static const IMAGEURL = "imageUrl";
  Map<String,dynamic> data;
  Product.fromJson(String jsonString) {
    data = json.decode(jsonString);
  }
  String get name => data[NAME]; 
  set name(String v) {data[NAME] = v;} 
  String get id => data[ID]; 
  set id(String v) {data[ID] = v;} 
  int get amount => data[AMOUNT]; 
  set amount(int v) {data[AMOUNT] = v;} 
  String get imageUrl => data[IMAGEURL]; 
  set imageUrl(String v) {data[IMAGEURL] = v;} 
}

class ProductsBloc implements Disposable {
  List<Product> _productList;
  final Category _category;
  final _productStream = StreamController<List<Product>>();
  ProductsBloc(this._category) {getProducts();}
  Stream<List<Product>> get products => _productStream.stream;
  @override
  void dispose() {
    _productStream.close();
    print("*** ${this.runtimeType} for ${_category.name} is disposed");
  }
  void getProducts() async {
    _productList = await DbApi.me.getProducts(_category);
    _productStream.add(_productList);
  }
}