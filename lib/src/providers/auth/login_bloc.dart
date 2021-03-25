import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challange/src/screens/user/profile_screen.dart';
import 'package:flutter_challange/src/widgets/custom_widget.dart';
import 'package:flutter_challange/src/widgets/the_loader.dart';
import 'package:flutter_challange/src/services/auth_sevice.dart';
import 'package:flutter_challange/src/models/auth/login_model.dart';

import '../../helpers/preferences_base.dart';
import '../../models/auth/login_model.dart';

class LoginBloc extends ChangeNotifier {
  BuildContext _context;

  CustomLoader loader = CustomLoader();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final _repository = AuthService();
  LoginResponseModel _auth;
  LoginModel loginModel = LoginModel();

  final emailController = TextEditingController();
  String _email;
  String get email => _email;
  setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  final passwordController = TextEditingController();
  String _password;
  String get password => _password;
  setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  LoginBloc() {
    emailController.addListener(() {
      setEmail(emailController.text);
    });
    passwordController.addListener(() {
      setPassword(passwordController.text);
    });
  }

  didMount(context) {
    _context = context;
  }

  onSubmit() async {
    try {
      loader.showLoader(_context);
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      loader.hideLoader();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('==> No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('==> Wrong password provided for that user.');
      }
      loader.hideLoader();
      customSnackBar(scaffoldKey, e.message, backgroundColor: Colors.redAccent);
    }
  }

  clearEmailValue() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => emailController.clear());
  }

  clearPasswordValue() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => passwordController.clear());
  }
}
