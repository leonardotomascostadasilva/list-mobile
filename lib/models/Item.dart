import 'dart:io';

import 'package:camera/camera.dart';

class Item{
  late String _id;
  late String _name;
  late int _amount;
  late double _price;
  late bool _active = false;
  late File file = File("");

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get name => _name;

  double get price => _price;

  set price(double value) {
    _price = value;
  }

  int get amount => _amount;

  set amount(int value) {
    _amount = value;
  }
  bool get active => _active;

  set active(bool value) {
    _active = value;
  }

  set name(String value) {
    _name = value;
  }
}

