import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_challange/src/providers/auth/login_bloc.dart';
import 'package:flutter_challange/src/providers/auth/register_bloc.dart';
import 'package:flutter_challange/src/screens/auth/login_screen.dart';
import 'package:flutter_challange/src/screens/auth/register_screen.dart';
import 'package:flutter_challange/src/services/auth_sevice.dart';
import 'package:provider/provider.dart';
import 'package:flutter_challange/src/helpers/helpers.dart';
import 'package:flutter_challange/src/providers/splash/splash_bloc.dart';
import 'package:flutter_challange/src/screens/splash/splash_screen.dart';
import 'package:flutter_challange/src/screens/user/profile_screen.dart';
import 'package:flutter_challange/src/providers/user/user_bloc.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => new _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent, // Color for Android
        statusBarBrightness:
            Brightness.light // Dark == white status bar -- for IOS.
        ));

    return MultiProvider(
      providers: [
        Provider<SplashBloc>(
          create: (_) => SplashBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Challange',
        theme: ThemeData(fontFamily: 'Nunito', brightness: Brightness.light),
        onGenerateRoute: routes,
        navigatorKey: Helpers.navigatorKey,
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  static Route<dynamic> routes(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return ChangeNotifierProvider<SplashBloc>.value(
              value: SplashBloc(),
              child: SplashScreen(),
            );
          },
        );
      case LoginScreen.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return ChangeNotifierProvider<LoginBloc>.value(
              value: LoginBloc(),
              child: LoginScreen(),
            );
          },
        );
      case RegisterScreen.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return ChangeNotifierProvider<RegisterBloc>.value(
              value: RegisterBloc(),
              child: RegisterScreen(),
            );
          },
        );
      case ProfileScreen.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return ChangeNotifierProvider<UserBloc>.value(
              value: UserBloc(),
              child: ProfileScreen(),
            );
          },
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
