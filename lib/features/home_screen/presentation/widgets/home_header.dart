import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String profilePicUrl;

  const HomeHeader({Key? key, required this.profilePicUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Evening,',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Alex',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(profilePicUrl),
            backgroundColor: Colors.grey[800],
          ),
        ],
      ),
    );
  }
}
