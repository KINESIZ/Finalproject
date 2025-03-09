import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miniproject/constant/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Registerfirebase extends StatefulWidget {
  const Registerfirebase({super.key});

  @override
  State<Registerfirebase> createState() => _RegisterfirebaseState();
}

class _RegisterfirebaseState extends State<Registerfirebase> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController name = TextEditingController();

  Future<void> submit() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
        
      );

      print("Register Success: ${userCredential.user?.email}");

      // สามารถเพิ่มโค้ดบันทึกชื่อใน Firestore ได้ที่นี่ถ้าต้องการ
    } on FirebaseAuthException catch (e) {
      print("Error Code: ${e.code}");
      print("Error Message: ${e.message}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Registration failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Firebase'),
        backgroundColor: pColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextField(
                controller: email,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: password,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              TextField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submit,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
