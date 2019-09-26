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
// T as type of disposable for provider/consumer, D as type of data for stream builder
// Child is for the consumer part, but can be used within the builder method of
// the stream builder, since it is available in the child instance variable.
class DisposableStream<T extends Disposable,D>  extends StatelessWidget {  
  final Widget child;
  @required final T _disposable;
  final Stream<D> Function(T disposable) stream;
  final D initialData;
  void _disposerProxy(BuildContext context, T value) {_disposable?.dispose();}
  T _builderProxy(BuildContext context) => _disposable;
  final AsyncWidgetBuilder<D> builder;
  DisposableStream({
    @required T value,
    this.stream,
    this.initialData,
    this.builder,
    this.child,
  }): _disposable = value;
  @override
  Widget build(BuildContext context) => Provider<T>(
    builder: _builderProxy,
    dispose: _disposerProxy,
    child: Consumer<T>(
      builder: (context,disposable,child) => StreamBuilder<D>(
        stream: stream(disposable),
        initialData: initialData,
        builder: builder,), 
      child: child),
  );
}