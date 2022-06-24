import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/views/widgets/ButtonCustom.dart';
import 'package:project/views/widgets/InputCustom.dart';

import '../controllers/ItemsController.dart';
import '../controllers/NewItemController.dart';
import '../models/Item.dart';

class ShareList extends StatefulWidget {
  const ShareList({Key? key}) : super(key: key);

  @override
  State<ShareList> createState() => _ShareListState();
}

class _ShareListState extends State<ShareList> {
  final TextEditingController _controllerEmail = TextEditingController();
  String _errorMessage = "";
  final _formKey = GlobalKey<FormState>();

  _validateFieldsAndSave() async {
    String email = _controllerEmail.text;

    FirebaseAuth auth = FirebaseAuth.instance;

    var data = await FirebaseFirestore.instance
        .collection("users")
        .doc(auth.currentUser!.email)
        .get();

    List items = data.data()!['items'];
    if (items.contains(email)) {
    } else {
      items.add(email);
      FirebaseFirestore db = FirebaseFirestore.instance;
      db.collection("users").doc(auth.currentUser!.email).update({
        "items": items,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Compartilhar Lista"),
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
                    controller: _controllerEmail,
                    hintText: "Email",
                    autofocus: true,
                    textInputType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: ButtonCustom(
                      text: "Receber Lista",
                      onPressed: () {
                        _validateFieldsAndSave();
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(
                            context, "/lista-compras");
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
