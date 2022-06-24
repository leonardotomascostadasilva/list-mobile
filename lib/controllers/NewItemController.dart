import 'package:project/controllers/ItemsController.dart';

import '../models/Item.dart';

class NewItemController {
  final ItemsController _itemsController = ItemsController();

  insertItem(String id, String nameItem, String amountItem, String priceItem) {
    Item item = Item();
    item.id = id;
    item.name = nameItem;
    item.amount = int.parse(amountItem);
    item.price = double.parse(priceItem);
    _itemsController.add(item);
  }
}
