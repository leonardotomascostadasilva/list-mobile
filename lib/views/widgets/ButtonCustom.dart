import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {

  final String text;
  final Color colorText;
  final VoidCallback onPressed;

  ButtonCustom({
    required this.text,
    this.colorText = Colors.white,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6)
      ),
      child: Text(
        text,
        style: TextStyle(color: colorText, fontSize: 20),
      ),
      color: Colors.lightBlueAccent,
      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
      onPressed: onPressed,
    );
  }
}
