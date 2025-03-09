import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isHoveringRegister = false;
  bool isHoveringLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/RMUTI-logo.png', 
                width: 150, // กำหนดขนาดรูปภาพ (ถ้าต้องการ)
              ),
              SizedBox(height: 30),
              btnRegisterfirebase(context),
              SizedBox(height: 15),
              btnFirebaseLogin(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget btnRegisterfirebase(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHoveringRegister = true),
      onExit: (_) => setState(() => isHoveringRegister = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => isHoveringRegister = true),
        onTapUp: (_) => setState(() => isHoveringRegister = false),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: isHoveringRegister ? 220 : 200,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, 'registerfirebase');
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(
              'Register',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blueAccent),
            ),
          ),
        ),
      ),
    );
  }

  Widget btnFirebaseLogin(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHoveringLogin = true),
      onExit: (_) => setState(() => isHoveringLogin = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => isHoveringLogin = true),
        onTapUp: (_) => setState(() => isHoveringLogin = false),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: isHoveringLogin ? 220 : 200,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, 'firebaselogin');
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(
              'Login',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.purpleAccent),
            ),
          ),
        ),
      ),
    );
  }
}
