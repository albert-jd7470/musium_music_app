import 'package:flutter/material.dart';

class AlbumArtDisplay extends StatelessWidget {
  final String imageUrl;

  const AlbumArtDisplay({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      decoration: BoxDecoration(
        color: const Color(0xFF222222), // Dark grey card background
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'NOW PLAYING',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: MediaQuery.of(context).size.width - 80, // square aspect ratio approximately
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
