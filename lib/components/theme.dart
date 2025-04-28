import 'dart:ui'; 
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF6C63FF),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
    elevation: 4,
  );

 static AppBar buildAppBar(String title, {List<Widget>? actions}) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
    ),
    backgroundColor: Colors.transparent, 
    elevation: 0,
    toolbarHeight: 100,
    actions: actions,
    centerTitle: true,
  );
}


  static ThemeData lightTheme = ThemeData(
    fontFamily: GoogleFonts.poppins().fontFamily,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
  );
}

class BackgroundWrapper extends StatelessWidget {
  final Widget child;
  const BackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 6,
              sigmaY: 6,
            ),
            child: Container(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
        SafeArea(
          child: child,
        ),
      ],
    );
  }
}
