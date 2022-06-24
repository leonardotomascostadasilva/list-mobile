import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/controllers/ItemsController.dart';
import 'package:project/views/widgets/ButtonCustom.dart';
import 'package:project/views/widgets/InputCustom.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _controllerEmail =
      TextEditingController(text: "admin@admin.com");
  final TextEditingController _controllerPassword =
      TextEditingController(text: "123456");
  bool _create = false;
  String _errorMessage = "";
  String _textButton = "Entrar";
  final ItemsController _itemsController = ItemsController();

  registrar(String email, String senha) async {
    var dataItem = await FirebaseFirestore.instance.collection("users").get();

    var isEmailValid = true;
    for (var user in dataItem.docs) {
      if (user.id == email) {
        isEmailValid = false;
      }
    }

    if (isEmailValid) {
      try {
        FirebaseAuth auth = FirebaseAuth.instance;
        auth
            .createUserWithEmailAndPassword(email: email, password: senha)
            .then((firebaseUser) => {});
      } on FirebaseAuthException catch (e, s) {
        _handleFirebaseLoginWithCredentialsException(e, s);
      } on Exception catch (e, s) {
        setState(() {
          _errorMessage = "Error";
        });
      }

      FirebaseFirestore db = FirebaseFirestore.instance;
      db.collection("users").doc(email).set({
        "email": email,
        "password": senha,
        "items": [],
      });
      Navigator.pushReplacementNamed(context, "/lista-compras");
    } else {
      setState(() {
        _errorMessage = "Conta já existe";
      });
    }
  }

  login(String email, String senha) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth
          .signInWithEmailAndPassword(email: email, password: senha)
          .then((firebaseUser) {});
    } on FirebaseAuthException catch (e, s) {
      _handleFirebaseLoginWithCredentialsException(e, s);
    } on Exception catch (e) {
      setState(() {
        _errorMessage = "Error";
      });
    }
  }

  void _handleFirebaseLoginWithCredentialsException(
      FirebaseAuthException e, StackTrace s) {
    if (e.code == 'user-not-found') {
      setState(() {
        _errorMessage = "Usuario não cadastrado";
      });
    } else if (e.code == 'invalid-email') {
      setState(() {
        _errorMessage = "Email invalido";
      });
    } else if (e.code == 'wrong-password') {
      setState(() {
        _errorMessage = "Senha incorreta";
      });
    } else {
      _errorMessage = "Error";
    }
  }

  _validateFields() {
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    if (email.isNotEmpty && email.contains("@") && email.contains(".")) {
      if (password.isNotEmpty && password.length >= 6) {
        if (_create) {
          registrar(email, password);
        } else {
          login(email, password);
          _itemsController.viewList2();
          Navigator.pushReplacementNamed(context, "/lista-compras");
        }
      } else {
        setState(() {
          _errorMessage = "Preencha a senha! digite mais de 6 caracteres.";
        });
      }
    } else {
      setState(() {
        _errorMessage = "Preencha o E-mail válido.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de compras"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
            child: SingleChildScrollView(
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 32),
              child: Image.asset(
                "images/LoginImage.png",
                width: 200,
                height: 150,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: InputCustom(
                controller: _controllerEmail,
                hintText: "E-mail",
                autofocus: true,
                textInputType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: InputCustom(
                controller: _controllerPassword,
                hintText: "Senha",
                obscureText: true,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Logar"),
                Switch(
                    value: _create,
                    onChanged: (bool value) {
                      setState(() {
                        _create = value;
                        _textButton = "Entrar";
                        if (_create) {
                          _textButton = "Cadastrar";
                        }
                      });
                    }),
                Text("Cadastrar"),
              ],
            ),
            ButtonCustom(
                text: _textButton,
                onPressed: () {
                  setState(() {
                    _errorMessage = "";
                  });
                  _validateFields();
                }),
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
        ))),
      ),
    );
  }
}
