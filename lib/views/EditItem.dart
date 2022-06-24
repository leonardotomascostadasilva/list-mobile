import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project/views/widgets/ButtonCustom.dart';
import 'package:project/views/widgets/InputCustom.dart';

import '../controllers/ItemsController.dart';
import '../controllers/NewItemController.dart';
import '../models/Item.dart';

class EditItem extends StatefulWidget {
  Item item;
  EditItem({Key? key, required this.item}) : super(key: key);

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  final TextEditingController _controllerNameItem = TextEditingController();
  final TextEditingController _controllerAmount = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  final ItemsController _itemsController = ItemsController();
  String _errorMessage = "";
  final _formKey = GlobalKey<FormState>();

  _editItem() {
    String nameItem = _controllerNameItem.text;
    String amountItem = _controllerAmount.text;
    String priceItem = _controllerPrice.text;

    if (nameItem.isEmpty) {
      nameItem = widget.item.name;
    }
    if (amountItem.isEmpty) {
      amountItem = widget.item.amount.toString();
    }
    if (priceItem.isEmpty) {
      priceItem = widget.item.price.toString();
    }
    Item itemUpdate = Item();
    itemUpdate.name = nameItem;
    itemUpdate.amount = int.parse(amountItem);
    itemUpdate.price = double.parse(priceItem);

    _itemsController.update(itemUpdate, widget.item);

    Navigator.pop(context);
    Navigator.pushNamed(context, "/lista-compras");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo item"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: InputCustom(
                    controller: _controllerNameItem,
                    hintText: widget.item.name,
                    autofocus: true,
                    textInputType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: InputCustom(
                    controller: _controllerAmount,
                    hintText: widget.item.amount.toString(),
                    autofocus: true,
                    textInputType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: InputCustom(
                    controller: _controllerPrice,
                    hintText: widget.item.price.toString(),
                    autofocus: true,
                    textInputType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: ButtonCustom(
                      text: "Editar item",
                      onPressed: () {
                        _editItem();
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
