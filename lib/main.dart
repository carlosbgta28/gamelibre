import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba/games/DesarrolloSoftware/level11/theme/preferences.dart';
import 'package:prueba/model/dbhelper.dart';

import 'package:prueba/view/home_screen.dart';
import 'package:prueba/view/login_screen.dart';
import 'package:prueba/services/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //provider
  await Preferencess.init();

  //keep user loged in
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var email = preferences.getString('email');

  //init db sqlite
  await DatabaseHandler().initializeDB();

//sharedPreferences init
  await LocalStorage.configurePrefs();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: email == null ? MyApp() : HomeScreen(),
  ));

  /* MaterialApp(
    debugShowCheckedModeBanner: false,
    home: email == null ? MyApp() : const HomeScreen(),
   )*/
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iniciar Sesión',
      theme: ThemeData(primarySwatch: Colors.red),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}


/* import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prueba/games/DesarrolloSoftware/level2/level2.dart';
import 'package:prueba/view/home_screen.dart';
import 'package:prueba/view/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //keep user loged in
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var email = preferences.getString('email');

  //init db sqlite
  //await DatabaseHandler().initializeDB();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: email == null ? MyApp() : const HomeScreen(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iniciar Sesión',
      theme: ThemeData(primarySwatch: Colors.red),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
} */