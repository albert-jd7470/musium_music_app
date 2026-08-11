import 'package:flutter/material.dart';
import '../../../../features/home_screen/data/dummy_data.dart';

class ProfileStatsRow extends StatelessWidget {
  final UserProfile profile;

  const ProfileStatsRow({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatColumn(profile.songsCount, 'SONGS'),
          _buildStatColumn(profile.playlistsCount, 'PLAYLISTS'),
          _buildStatColumn(profile.listeningHours, 'LISTENING'),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
