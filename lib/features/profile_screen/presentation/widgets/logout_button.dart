import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogoutButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          side: BorderSide(color: Colors.white.withOpacity(0.2)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
        ),
        icon: const Icon(
          Icons.logout,
          color: Color(0xFFEAA088), // Peach/salmon color from design
          size: 20,
        ),
        label: const Text(
          'Log Out',
          style: TextStyle(
            color: Color(0xFFEAA088),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
