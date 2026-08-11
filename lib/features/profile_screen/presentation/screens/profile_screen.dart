import 'package:flutter/material.dart';
import '../../../../features/home_screen/data/dummy_data.dart';
import '../widgets/logout_button.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_stats_row.dart';
import '../widgets/settings_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = DummyData.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100.0), // Padding for the bottom nav bar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeaderCard(profile: user),
                ProfileStatsRow(profile: user),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SettingsItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  subtitle: 'System default',
                  isHighlighted: true,
                  trailing: Switch(
                    value: true,
                    onChanged: (val) {},
                    activeColor: Colors.black,
                    activeTrackColor: Colors.white,
                  ),
                ),
                const SettingsItem(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: 'English (US)',
                  trailing: Icon(Icons.chevron_right, color: Colors.white54),
                ),
                const SettingsItem(
                  icon: Icons.notifications_none,
                  title: 'Notifications',
                  subtitle: 'Push, Email',
                  trailing: Icon(Icons.chevron_right, color: Colors.white54),
                ),
                const SettingsItem(
                  icon: Icons.download_outlined,
                  title: 'Downloads',
                  subtitle: 'Wi-Fi only, 12GB used',
                  trailing: Icon(Icons.chevron_right, color: Colors.white54),
                ),
                const SettingsItem(
                  icon: Icons.lock_outline,
                  title: 'Privacy',
                  subtitle: 'Data & Permissions',
                  trailing: Icon(Icons.chevron_right, color: Colors.white54),
                ),
                LogoutButton(onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
