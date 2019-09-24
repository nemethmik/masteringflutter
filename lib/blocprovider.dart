import "package:flutter/material.dart";
abstract class Disposable {
  void dispose();
}
class BlocProvider<T extends Disposable> extends StatefulWidget {
  @required final T bloc;
  final Widget child;
  const BlocProvider({Key key, @required this.bloc, @required this.child}) : super(key: key);
  @override State<StatefulWidget> createState() {
    return _BlocProviderState<T>();
  }
  static T of<T extends Disposable>(BuildContext context){
    final type = _typeof<BlocProvider<T>>();
    BlocProvider<T> p = context.ancestorWidgetOfExactType(type);
    return p.bloc;
  }
  static Type _typeof<T>() => T; //This is a tricky thing :)
}
class _BlocProviderState<T> extends State<BlocProvider<Disposable>> {
  @override void dispose() {
    try{widget.bloc.dispose();}
    finally{super.dispose();}
  }
  @override Widget build(BuildContext context) => widget.child;
} 