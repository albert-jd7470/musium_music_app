import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF222222), // Dark grey background
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Artists, songs, or podcasts...',
            hintStyle: TextStyle(
              color: Colors.white54,
              fontSize: 16,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white54,
            ),
            suffixIcon: Icon(
              Icons.mic_none,
              color: Colors.white54,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 16.0),
          ),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
