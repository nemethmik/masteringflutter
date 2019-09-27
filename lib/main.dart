import 'package:flutter/material.dart';
import 'package:masteringflutter/cart.dart';
import 'disposable.dart';
import 'homepage.dart';

void main() => runApp(DisposableProvider<CartBloc>(
  value: CartBloc(),
  child: MyApp())
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
