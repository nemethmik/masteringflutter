# masteringflutter

This is a remake of the project Robert Brunhage tought during his Masteting Flutter course. As usual I significantly adapted his code to my style.

## Getting Started

In section one the instructor anticipated using Firebase, and he used a named constructor Category.fromFirebase, since I have zero interst in Firebase, I used the name **Category.fromJson**, since Map<String,dynamic> is exactly the type returned by the json.decode function from the dart:convert package.
I created the demo categories with the **dart:convert** package from in-line JSON strings:
```dart
class DbApi {
  List<Category> getCategories(){
    return <Category>[
      Category.fromJson(json.decode('{"id":"01","name":"Motherboard"}')),
      Category.fromJson(json.decode('{"id":"02","name":"Screen"}')),
      Category.fromJson(json.decode('{"id":"03","name":"Pen"}')),
      Category.fromJson(json.decode('{"id":"04","name":"Earbud"}')),
    ];
  }
}
```

## Bloc Provider
Honestly, I don't believe in this provider pattern when used with BloCs. Provider is perfectly OK for the Change Notifier machiery, but when using Stream Builder, it makes no sense. Using streams to deliver data to UI was a brilliant idea, I love it, but that's all.
The only service of the provider is that it implements disposability since it is derived from a stateful widget.

After section 3, I am even more convinced that bloc provider is terribly cumbersome, fragile, and PITA.
In this example BlocProvider is wrapping the category page and provides 
a product bloc object to it.  
```dart
ListTile(
  onTap: () => Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => BlocProvider(
      bloc: ProductsBloc(snapshot.data[index]),
        child: CategoryPage(),
    ))),
  title: Text(snapshot.data[index].name,
      style: TextStyle(fontSize: 24.0),
    ),
);
```
There are two problems here:
- The smaller one is that the code is terribly complex, very hard to decipher what to look for.
- The major, grandioso problem is that nothing declares at compile time that the category page requires a product bloc. The compiler doesn't prevent the programmer here to define the wrong bloc.
For example, here the compiler happily compiles the code
```dart
  builder: (context) => BlocProvider(
    bloc: CategoriesBloc(),
    // bloc: ProductsBloc(snapshot.data[index]),
      child: CategoryPage(),
  ))),
```
and we are having an ugly runtime crash.
A lot simpler and lot more robust solution is required.
Passing blocs as parameters is far the safest way; when you just randomly wants a bloc by using BlocProvider.of it is absolutely not guaranteed that the proper bloc has been provided in any upper level.
With some code restructuring, the blocs may disappear.
The global service locator solution is a lot simpler and more robust, since the location of the blocs are independent of the widget hierarchy.
Whenever, the category page requires a bloc, it should request one from a service locator.

On the other hand, every time whenever you create a page you wrap it with bloc provider, like so:
```dart
BlocProvider(
  bloc: ProductsBloc(snapshot.data[index]),
  child: CategoryPage(),
),
```
This sees ok, but in this case why not simply pass the bloc to the page as a parameter? It would be really safe, since the compiler guarantees that you provide the correct bloc to the page.

## BloC Disposing Stateful Pages
In this commit, I removed bloc provider entirely and I changed all the two pages to a stateful widget just to be able to dispose the blocs.
The category page received a Category parameter, this is the clean and straightforward way in this architecture where Robert Brunhage didn't introduced the concept of an application logic component.
Here, blocs are only for serving data to the pages, and the navigation control and UI event handling all are done by the widgets themselves.
This is not necessarily bad, but definitely, when you want to understand how the application works, you have to read the entire source code.
When having interfaces for events and commands, it's enough just to review them.
What is tricky here that the products bloc is created with a category parameter, so a singleton global producs bloc is not enough for this architecture. Actually, I like this approach, since every time a category page is opened the products for that category are retrieved, and therefore we don't need a broadcast stream, since the products stream in the products bloc is only listened once, just like as in a HTTP API call. 
If I used a global singleton products bloc, its products stream should have been defined as a broadcast stream to be ok to serve all category pages during the life of the application. 
I think that would be a lot simpler solution since then we wouldn't need stateful pages, nor provider package, since a mobile application typically shows one page at a time, no need to create multiple products blocks. page specific blocs/query results could have even been cached in a global singleton bloc, too.
So whatever hard I study and experiment in this area, I am fully convinced that a single application logic bloc, with broadcast streams could serve the entire application, or at least an entire module/workflow/business process (Goods Receipt, Delivery, Issue for Production, and so on).
```dart
class CategoryPage extends StatefulWidget {
  final Category category;
  const CategoryPage(this.category,{Key key,}) : super(key: key);
  @override _CategoryPageState createState() => _CategoryPageState();
}
class _CategoryPageState extends State<CategoryPage> {
  ProductsBloc bloc;
  @override void dispose() {
    bloc?.dispose(); // If bloc is not null dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    bloc ??= ProductsBloc(widget.category); // If bloc is null, initialize it
    return Scaffold(
...      
```
In the code sample above, category entity/model object is received as a parameter, and the bloc is created in the state object is built. When the state object is disposed, it disposes the bloc, too.
This is called cumbersome boiler-plate, which could be nicely eliminated with rearchitecting the application with using singleton blocs (with broadcast streams) only. 

## Provider Alone is not Enough
This doesn't work 
```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<CategoriesBloc>(
      builder: (context) => CategoriesBloc(),
      dispose: (context,value) => value?.dispose(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("E-Commerce"),
        ),
        body: StreamBuilder<List<Category>>(
          stream: Provider.of<CategoriesBloc>(context).categories,
          builder: (context,snapshot){
```
we receive an exception:
The following ProviderNotFoundError was thrown building HomePage(dirty):
Error: Could not find the correct Provider<CategoriesBloc> above this HomePage Widget. Ensure the Provider<CategoriesBloc> is an ancestor to this HomePage Widget.

## Provider and Consumer Works Fine
Using
[consumer](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple#consumer) with provider:
```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<CategoriesBloc>(
      builder: (context) => CategoriesBloc(),
      dispose: (context,bloc) => bloc?.dispose(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("E-Commerce"),
        ),
        body: Consumer<CategoriesBloc>(
          builder: (context,bloc,child) => StreamBuilder<List<Category>>(
            stream: bloc.categories,
            builder: (context,snapshot){
```
Dispose is not automatic, but we could make our generic bloc-disposing provider class easily, if we wanted to.
**Provider.value** is not ok, since it doesn't have dispose parameter.

Here is an even more complete example with the category page where it receives a category entity/model object and makes its own bloc:
```dart
class CategoryPage extends StatelessWidget {
  final Category category;
  const CategoryPage(this.category,{Key key,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Provider<ProductsBloc>(
      builder: (context) => ProductsBloc(category),
      dispose: (context,bloc)=>bloc?.dispose(),
      child: Scaffold(
        appBar: AppBar(),
        body: Consumer<ProductsBloc>(
          builder: (context,bloc,child) => StreamBuilder<List<Product>>(
            stream: bloc.products,
            builder: (context,snapshot){
``` 
So, the category stateless page has a mandatory parameter, which is guaranteed by the Dart compiler.
The build function creates a products bloc provider widget, which actually builds a provider bloc object, and gives the chance to dispose it when the page is destroyed. The stream builder is enclosed within a consumer widget's builder to get access to the provider's bloc.

## StreamProvider Gives no Disposability
Stream provider along with Consumer would work, too, but stream provider has no dispose parameter, which is absolutely a no-no when working with streams. This is a big oversight and mistake, since it could have been the least cumbersome solution of all these provider possibilities. 
```dart
class CategoryPage extends StatelessWidget {
  final Category category;
  const CategoryPage(this.category,{Key key,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Product>>(
      builder: (context) => ProductsBloc(category).products,
      //dispose: (context,bloc)=>bloc?.dispose(),
      child: Scaffold(
        appBar: AppBar(),
        body: Consumer<List<Product>>(
          builder: (context,products,child) {
              if(products != null) {
                return GridView.builder(
```

## Disposable Provider
Here is my simple implementation of a provider of a disposable object
```dart
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
```
And here is an example how to use it with a Consumer and Stream Builder
```dart
class CategoryPage extends StatelessWidget {
  final Category category;
  const CategoryPage(this.category,{Key key,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DisposableProvider<ProductsBloc>(
      value: ProductsBloc(category),
      child: Scaffold(
        appBar: AppBar(),
        body: Consumer<ProductsBloc>(
          builder: (context,bloc,child) => StreamBuilder<List<Product>>(
            stream: bloc.products,
            builder: (context,snapshot){
              if(snapshot.hasData) {
```

## Disposable Consumer
```dart
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
```
How to use disposable consumer:
```dart
class CategoryPage extends StatelessWidget {
  final Category category;
  const CategoryPage(this.category,{Key key,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: DisposableConsumer<ProductsBloc>(
          value: ProductsBloc(category),
          builder: (context,bloc,child) => StreamBuilder<List<Product>>(
            stream: bloc.products,
            builder: (context,snapshot){
              if(snapshot.hasData) {
```
Practically a provider with an immediate consumer.

## Disposable Stream Builder
The top model of this series is this class. The value parameter expects a disposable object, typically a bloc.
The stream is a function to return a stream, the function parameter is the bloc provided as the value. 
initialData and builder are for the stream builder.
The optional child is for the consumer. This value can be used within the builder as this.child.
```dart
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
```
Here is an example how simple it is to use it.
```dart
class CategoryPage extends StatelessWidget {
  final Category category;
  const CategoryPage(this.category,{Key key,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: DisposableStream<ProductsBloc,List<Product>>(
          value: ProductsBloc(category),
          stream: (bloc) => bloc.products,
          builder: (context,snapshot){
            if(snapshot.hasData) {
```
all this fuss is just to make give automated disposability within stateless widgets to the blocs.
Practically this is a replacement for the stream builder where it consumes an auto-disposed bloc.
If Dart had destructor machinery just like every major programming languages, this wouldn't be needed.

## RX Dart Behavior Subject
Regular non-broadcast streams can be listened only once, and only by one listener, which is perfectly fine for receiving the data from a HTTP or databse request/query, when the data has been downloaded, the stream has to be closed.

[BehaviorSubject](https://pub.dev/documentation/rxdart/latest/rx/BehaviorSubject-class.html) is broadcast stream, and emits the last item as the first item to any new listener. After that, any new events will be appropriately sent to the listeners. This means the Subject's stream can be listened to multiple times.

This is exactly how LiveData streams behave in Android Architecture. These are not OK for sending events, for example.
