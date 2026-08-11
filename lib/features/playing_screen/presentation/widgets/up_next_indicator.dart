import 'package:flutter/material.dart';

class UpNextIndicator extends StatelessWidget {
  const UpNextIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        children: [
          const Icon(
            Icons.keyboard_arrow_up,
            color: Colors.white70,
            size: 20,
          ),
          Text(
            'UP NEXT',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }
}
