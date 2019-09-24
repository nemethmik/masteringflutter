import 'package:masteringflutter/category.dart';
import 'dart:convert';

import 'package:masteringflutter/product.dart';
abstract class DbApi {
  Future<List<Category>> getCategories();
  Future<List<Product>> getProducts(Category category);
  static DbApi get me {return _me;}
  static DbApi _me = _DbApi();
} 
class _DbApi implements DbApi {
  @override Future<List<Category>> getCategories() async {
    await Future.delayed(Duration(seconds: 2));
    return <Category>[
      Category.fromJson(json.decode('{"id":"01","name":"Motherboard"}')),
      Category.fromJson(json.decode('{"id":"02","name":"Screen"}')),
      Category.fromJson(json.decode('{"id":"03","name":"Pen"}')),
      Category.fromJson(json.decode('{"id":"04","name":"Earbud"}')),
    ];
  }
  @override
  Future<List<Product>> getProducts(Category category) async {
    await Future.delayed(Duration(seconds: 2));
    return <Product>[
      Product.fromJson('{"id":"01","name":"Spion","amount":10}'),
      Product.fromJson('{"id":"02","name":"Xenon","amount":324}'),
    ];
  }
}