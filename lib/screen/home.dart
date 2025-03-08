import 'package:miniproject/constant/constant.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pColor,
        title: Text(
          "Mini Project",
          style: TextStyle(
            fontSize: pFont,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            btnRegisterfirebase(context),
            btnFirebaseLogin(context),

          ],
        ),
      ),
    );
  }

  Widget btnRegisterfirebase(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, 'registerfirebase');
      },
      child: Text('Register Firebase'),
    );   
  }

  Widget btnFirebaseLogin(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, 'firebaselogin');
      },
      child: Text('Firebase Login'),
    );   
  }
}