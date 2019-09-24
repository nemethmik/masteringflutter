class Category {
  static const NAME = "name";
  String id;
  String name;
  Category.fromJson(Map<String,dynamic> jsonMap){
    name = jsonMap[NAME];
  }
}