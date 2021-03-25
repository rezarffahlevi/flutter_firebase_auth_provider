import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challange/src/helpers/preferences_base.dart';
import 'package:flutter_challange/src/helpers/validators.dart';
import 'package:flutter_challange/src/models/auth/login_model.dart';
import 'package:flutter_challange/src/models/auth/register_model.dart';
import 'package:flutter_challange/src/screens/user/profile_screen.dart';
import 'package:flutter_challange/src/services/auth_sevice.dart';
import 'package:flutter_challange/src/widgets/custom_widget.dart';
import 'package:flutter_challange/src/widgets/the_loader.dart';

class RegisterBloc extends ChangeNotifier {
  BuildContext _context;

  CustomLoader loader = CustomLoader();
  final formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final _repository = AuthService();
  LoginResponseModel _auth;
  LoginModel loginModel = LoginModel();
  RegisterModel registerModel = RegisterModel();

  final namaController = TextEditingController();
  String _nama;
  String get nama => _nama;
  setNama(String nama) {
    _nama = nama;
    notifyListeners();
  }

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

  final passwordController2 = TextEditingController();
  String _password2;
  String get password2 => _password2;
  setPassword2(String password2) {
    _password2 = password2;
    notifyListeners();
  }

  RegisterBloc() {
    namaController.addListener(() {
      setNama(namaController.text);
    });
    emailController.addListener(() {
      setEmail(emailController.text);
    });
    passwordController.addListener(() {
      setPassword(passwordController.text);
    });
    passwordController2.addListener(() {
      setPassword2(passwordController2.text);
    });
  }

  didMount(context) {
    _context = context;
  }

  onSubmit() async {
    try {
      if (await validate()) {
        loader.showLoader(_context);
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        loader.hideLoader();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      loader.hideLoader();
      customSnackBar(scaffoldKey, e.message, backgroundColor: Colors.redAccent);
    } catch (e) {
      print(e);
      loader.hideLoader();
      customSnackBar(scaffoldKey, e.message, backgroundColor: Colors.redAccent);
    }
  }

  validate() {
    bool validated = true;
    [_nama, _email, _password, _password2].forEach((dt) {
      if (Validators.isNull(dt)) {
        validated = false;
      }
      return validated;
    });
    if (!validated)
      customSnackBar(scaffoldKey, 'Semua field wajib di isi',
          backgroundColor: Colors.redAccent);
    else if (password != _password2) {
      customSnackBar(scaffoldKey, 'Password dan konfirmasi password tidak sama',
          backgroundColor: Colors.redAccent);
      validated = false;
    }
    return validated;
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
