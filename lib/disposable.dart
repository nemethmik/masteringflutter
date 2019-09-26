import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

abstract class Disposable {
  void dispose();
}
class DisposableProvider<T extends Disposable>  extends StatelessWidget {  
  final Widget _child;
  @required final T _disposable;
  void _disposerProxy(BuildContext context, T value) {_disposable?.dispose();}
  T _builderProxy(BuildContext context) => _disposable;
  DisposableProvider({
    @required T value,
    Widget child,
  }): _child = child, _disposable = value;
  @override
  Widget build(BuildContext context) => Provider<T>(builder: _builderProxy,dispose: _disposerProxy,child: _child,);
}

class DisposableConsumer<T extends Disposable>  extends StatelessWidget {  
  final Widget _child;
  @required final T _disposable;
  void _disposerProxy(BuildContext context, T value) {_disposable?.dispose();}
  T _builderProxy(BuildContext context) => _disposable;
  final Widget Function(BuildContext context, T value, Widget child) _builder;
  DisposableConsumer({
    @required T value,
    Widget Function(BuildContext context, T value, Widget child) builder,
    Widget child,
  }): _child = child, _disposable = value, _builder = builder;
  @override
  Widget build(BuildContext context) => Provider<T>(
    builder: _builderProxy,
    dispose: _disposerProxy,
    child: Consumer<T>(builder: _builder, child: _child),
  );
}