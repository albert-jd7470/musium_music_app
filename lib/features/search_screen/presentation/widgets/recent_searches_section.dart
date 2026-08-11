import 'package:flutter/material.dart';

class RecentSearchesSection extends StatelessWidget {
  final List<String> recentSearches;
  final Function(String) onSearchTapped;
  final VoidCallback onClearTapped;

  const RecentSearchesSection({
    Key? key,
    required this.recentSearches,
    required this.onSearchTapped,
    required this.onClearTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Searches',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: onClearTapped,
                child: Text(
                  'Clear',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            scrollDirection: Axis.horizontal,
            itemCount: recentSearches.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => onSearchTapped(recentSearches[index]),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.history,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        recentSearches[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
