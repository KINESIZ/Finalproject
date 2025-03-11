import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Miniproject/constant/constant.dart';
import 'package:Miniproject/firebase_options.dart';
import 'package:Miniproject/screen/home.dart';
import 'package:Miniproject/screen/loginfirebase.dart';
import 'package:Miniproject/screen/profile.dart';
import 'package:Miniproject/screen/registerfirebase.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Home(),
        theme: ThemeData(
          primaryColor: pColor,
          secondaryHeaderColor: sColor,
        ),
        routes: {
          
          'registerfirebase': (context) => Registerfirebase(),

          'firebaselogin': (context) => Firebaselogin(),
          'profile': (context) => Profile(),
          
          
        },
      );
  }
}