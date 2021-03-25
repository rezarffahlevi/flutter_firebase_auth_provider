import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_challange/src/helpers/helpers.dart';
import 'package:flutter_challange/src/screens/auth/login_screen.dart';
import 'package:flutter_challange/src/screens/user/profile_screen.dart';
import '../../helpers/preferences_base.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashBloc extends ChangeNotifier {
  BuildContext _context;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  bool _isLogin;
  bool get isLogin => _isLogin;
  setEmail(bool isLogin) {
    _isLogin = isLogin;
    notifyListeners();
  }

  SplashBloc() {
    getSomething();
  }

  didMount(context) {
    _context = context;
  }

  getSomething() async {
    var init = await _initialization;
    print('Initialized Firebase === > ${init.name}');
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      Navigator.popUntil(
          Helpers.navigatorKey.currentContext, (route) => route.isFirst);
      if (user == null) {
        Navigator.pushReplacementNamed(
            Helpers.navigatorKey.currentContext, LoginScreen.routeName);
        print('User is currently signed out!');
      } else {
        Navigator.pushReplacementNamed(
            Helpers.navigatorKey.currentContext, ProfileScreen.routeName);
        print('User is signed in!');
      }
    });

    // bool isLogin = !Validators.isNull(await Prefs.token);
    // Timer(Duration(seconds: 2), () {
    //   if (isLogin)
    //     Navigator.pushReplacementNamed(_context, ProfileScreen.routeName);
    //   else
    //     Navigator.pushReplacementNamed(_context, LoginScreen.routeName);
    // });
  }
}
