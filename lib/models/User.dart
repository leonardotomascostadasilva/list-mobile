import 'package:project/models/Item.dart';

class User {

  late String _id;
  late String _email;
  late String _password;
  late List<Item> _items;

  User(){
    _items = List.empty();
  }
  String get password => _password;

  set password(String value) {
    _password = value;
  }

  List<Item> get items => _items;

  set items(List<Item> value) {
    _items = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}