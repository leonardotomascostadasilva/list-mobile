import 'package:project/models/Item.dart';

import '../models/User.dart';

class UserController{

  UserController();

  addItem(Item item, User user) async {
    user.items.add(item);
  }

  remove(int index, User user) async {
    user.items.removeAt(index);
  }

  update(Item item, Item old, User user) async {
    int index = user.items.indexOf(old);
    user.items[index] = item;
  }

  viewList(User user){
    return user.items;
  }

  getItemName(int index, User user){
    return user.items[index].name;
  }
  getItem(int index, User user){
    return user.items[index];
  }
  getItemAmount(int index, User user){
    return user.items[index].amount;
  }
  getItemPrice(int index, User user){
    return user.items[index].price;
  }
}