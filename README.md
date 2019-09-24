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