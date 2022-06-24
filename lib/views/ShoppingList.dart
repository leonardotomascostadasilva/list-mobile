import 'package:flutter/material.dart';
import 'package:project/views/EditItem.dart';
import 'package:project/views/PictureItem.dart';
import 'package:project/views/widgets/InputCustom.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../controllers/ItemsController.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({Key? key}) : super(key: key);

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<String> itemsMenu = ["Atualizar", "Sair", "Receber lista", "Compartilhar lista"];
  final _formKey = GlobalKey<FormState>();
  final ItemsController _itemsController = ItemsController();
  double _total = 0;

  Widget listaDeItens() {
    return ListView.builder(
        itemCount: _itemsController.count(),
        itemBuilder: (BuildContext context, int index) {
          return _itemsController.count() <= 0
              ? Container()
              : GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PictureItem(
                                item: _itemsController.getItem(index))));
                  },
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Checkbox(
                              value: _itemsController.getItemFlag(index),
                              onChanged: (val) {
                                setState(() {
                                  var flag =
                                      _itemsController.getItemFlag(index);
                                  if (flag) {
                                    _itemsController.setItemFlag(index, val!);
                                    _total -= (_itemsController
                                            .getItemPrice(index) *
                                        _itemsController.getItemAmount(index));
                                    if (_total <= 0) _total = 0;
                                  } else {
                                    _itemsController.setItemFlag(index, val!);
                                    _total += (_itemsController
                                            .getItemPrice(index) *
                                        _itemsController.getItemAmount(index));
                                  }
                                });
                              },
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _itemsController.getItemName(index),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      "Quantidade: ${_itemsController.getItemAmount(index).toString()}"),
                                  Text(
                                      "R\$: ${(_itemsController.getItemPrice(index) * _itemsController.getItemAmount(index)).toStringAsFixed(2)}"),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: FlatButton(
                              color: Colors.red,
                              padding: EdgeInsets.all(10),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Confirmar"),
                                        content: Text(
                                            "Deseja realmente excluir o item?"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text(
                                              "Cancelar",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          FlatButton(
                                            color: Colors.red,
                                            child: Text(
                                              "Remover",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              _itemsController.remove(index);
                                              Navigator.of(context).pop();
                                              Navigator.pushReplacementNamed(
                                                  context, "/lista-compras");
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: FlatButton(
                              color: Colors.blue,
                              padding: EdgeInsets.all(10),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => EditItem(
                                            item: _itemsController
                                                .getItem(index))));
                              },
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        });
  }

  _chooseItemMenu(String chooseItem) {
    switch (chooseItem) {
      case "Atualizar":
        Navigator.pushReplacementNamed(context, "/lista-compras");
        break;
      case "Sair":
        _logoutUser();
        break;
      case "Compartilhar lista":
        Navigator.pushNamed(context, "/compartilhar-lista");
        break;
    }
  }

  _logoutUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    _itemsController.cleanList();
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _itemsController.viewList();
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista de compras"),
          elevation: 0,
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: _chooseItemMenu,
              itemBuilder: (context) {
                return itemsMenu.map((String item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList();
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, "/novo-item");
          },
        ),
        body: listaDeItens(),
        persistentFooterButtons: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "Total R\$: ${_total.toStringAsFixed(2)}",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    )),
              ])
        ]);
  }
}
