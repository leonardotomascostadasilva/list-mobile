import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:project/views/widgets/ButtonCustom.dart';
import 'package:project/views/widgets/InputCustom.dart';

import '../controllers/ItemsController.dart';
import '../controllers/NewItemController.dart';
import '../models/Item.dart';

class NewItem extends StatefulWidget {
  const NewItem({Key? key}) : super(key: key);

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final TextEditingController _controllerNameItem = TextEditingController();
  final TextEditingController _controllerAmount = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  final ItemsController _itemsController = ItemsController();
  final NewItemController _newItemController = NewItemController();
  late Item _item;
  String _errorMessage = "";
  final _formKey = GlobalKey<FormState>();

  _validateFieldsAndSave() async {
    String nameItem = _controllerNameItem.text;
    String priceItem = _controllerPrice.text;

    if (nameItem.isEmpty) {
      setState(() {
        _errorMessage = "Nome do item é obrigatório!";
      });
    }
    if (_controllerAmount.text.isEmpty) {
      setState(() {
        _errorMessage = "Quantidade do item é obrigatório!";
      });
    }
    if (priceItem.isEmpty) {
      setState(() {
        _errorMessage = "Preço do item é obrigatório!";
      });
    }

    if (nameItem.isNotEmpty &&
        _controllerAmount.text.isNotEmpty &&
        priceItem.isNotEmpty) {
      setState(() {
        _errorMessage = "";
      });

      

      var id = UniqueKey().toString();
      _newItemController.insertItem(id, nameItem, _controllerAmount.text, priceItem);
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore db = FirebaseFirestore.instance;
          db.collection("meus_items")
          .doc(auth.currentUser!.email)
          .collection("Items").doc(id)
          .set({
        "id": id,
        "name": nameItem,
        "amout": int.parse(_controllerAmount.text),
        "price": double.parse(priceItem),
        "active": false
      }).then((_) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, "/lista-compras");
      });
    }
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
                    hintText: "Nome do item",
                    autofocus: true,
                    textInputType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: InputCustom(
                    controller: _controllerAmount,
                    hintText: "Quantidade",
                    autofocus: true,
                    textInputType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: InputCustom(
                    controller: _controllerPrice,
                    hintText: "Preço",
                    autofocus: true,
                    textInputType: TextInputType.number,
                  ),
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
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: ButtonCustom(
                      text: "Cadastrar item",
                      onPressed: () {
                        _validateFieldsAndSave();
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
