import 'dart:async';

import 'package:masteringflutter/disposable.dart';
import 'package:masteringflutter/product.dart';
import 'package:rxdart/rxdart.dart';

class Cart {
  List<Product> products = List();
}
class CartBloc extends Disposable {
  Cart cart = Cart();
  final _productStream = BehaviorSubject<List<Product>>();
  Stream<List<Product>> get products => _productStream.stream;
  final _countStream = BehaviorSubject<int>();
  Stream<int> get count => _countStream.stream;
  @override
  void dispose() {
    _productStream.close();
    _countStream.close();
  }
  addProduct(Product p) {
    if(cart.products.contains(p)) {
      p.amount++;
    } else {
      p.amount = 1;
      cart.products.add(p);
    }
    _productStream.add(cart.products);
    _countStream.add(cart.products.length);
  }
}