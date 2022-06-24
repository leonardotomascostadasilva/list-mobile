import 'package:flutter/material.dart';
import 'package:project/models/Item.dart';
import 'package:project/views/EditItem.dart';
import 'package:project/views/Login.dart';
import 'package:project/views/NewItem.dart';
import 'package:project/views/PictureItem.dart';
import 'package:project/views/ShareList.dart';
import 'package:project/views/ShoppingList.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;

    switch (routeSettings.name) {
      case "/lista-compras":
        return MaterialPageRoute(builder: (_) => ShoppingList());
      case "/login":
        return MaterialPageRoute(builder: (_) => Login());
      case "/novo-item":
        return MaterialPageRoute(builder: (_) => NewItem());
      case "/compartilhar-lista":
        return MaterialPageRoute(builder: (_) => ShareList());
    }
    return _errorRoute();
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Tela não encontrada!"),
        ),
        body: Center(
          child: Text("Tela não encontrada!"),
        ),
      );
    });
  }
}
