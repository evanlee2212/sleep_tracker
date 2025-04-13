import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final double width;
  final double height;

  const MenuButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.width = 250,
    this.height = 60,
});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.deepPurpleAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          elevation: 5,
          shadowColor: Colors.deepPurple.withValues(alpha: 0.3),
          padding: const EdgeInsets.all(16),
        ),
        onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            )
          ),
      )
    );
  }
}