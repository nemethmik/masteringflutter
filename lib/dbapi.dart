import 'package:masteringflutter/category.dart';
import 'dart:convert';
abstract class DbApi {
  Future<List<Category>> getCategories();
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
}