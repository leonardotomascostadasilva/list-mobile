import 'dart:io';

//import 'package:camera_camera/camera_camera.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/views/DocumentosPage.dart';
import 'package:project/views/widgets/ButtonCustom.dart';
import 'package:project/views/widgets/InputCustom.dart';

import '../controllers/ItemsController.dart';
import '../controllers/NewItemController.dart';
import '../models/Item.dart';

class PictureItem extends StatefulWidget {
  Item item;
  PictureItem({Key? key, required this.item}) : super(key: key);

  @override
  State<PictureItem> createState() => _PictureItemState();
}

class _PictureItemState extends State<PictureItem> {
  final TextEditingController _controllerNameItem = TextEditingController();
  final TextEditingController _controllerAmount = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  final ItemsController _itemsController = ItemsController();
  String _errorMessage = "";
  CameraController? controller;
  bool isCameraReady = false;
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tirar Foto do produto"),
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
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                            if (widget.item.file.path.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(bottom: 24),
                                child: SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(widget.item.file,
                                          fit: BoxFit.cover),
                                    )),
                              ),
                            ]))),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: ButtonCustom(
                      text: "Tirar Foto",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    DocumentosPage(item: widget.item)));
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
