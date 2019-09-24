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
