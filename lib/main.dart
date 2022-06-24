import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/RouteGenerator.dart';
import 'package:project/views/Login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(MaterialApp(
    title: "Lista de compras",
    home: Login(),
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}
