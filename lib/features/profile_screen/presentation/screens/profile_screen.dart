import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/auth_provider.dart';
import '../widgets/logout_button.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_stats_row.dart';
import '../widgets/settings_item.dart';
import '../../../../features/home_screen/presentation/providers/trending_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100.0), // Padding for the bottom nav bar
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProfileHeaderCard(),
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
                    SettingsItem(
                      icon: Icons.language,
                      title: 'Language',
                      subtitle: context.watch<TrendingProvider>().selectedLanguage[0].toUpperCase() + context.watch<TrendingProvider>().selectedLanguage.substring(1),
                      trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                      onTap: () {
                        final trendingProvider = context.read<TrendingProvider>();
                        showModalBottomSheet(
                          context: context,
                          useRootNavigator: true,
                          backgroundColor: const Color(0xFF1E1E1E),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
                          ),
                          builder: (context) {
                            return SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Select Language',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ...trendingProvider.availableLanguages.map((String language) {
                                      final isSelected = trendingProvider.selectedLanguage == language;
                                      return ListTile(
                                        title: Text(
                                          language[0].toUpperCase() + language.substring(1),
                                          style: TextStyle(
                                            color: isSelected ? const Color(0xFF1ED760) : Colors.white,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                        trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF1ED760)) : null,
                                        onTap: () {
                                          trendingProvider.setLanguage(language);
                                          Navigator.pop(context);
                                        },
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    SettingsItem(
                      icon: Icons.lock_outline,
                      title: 'Privacy',
                      subtitle: 'Data & Permissions',
                      trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                      onTap: () {
                        context.push('/privacy');
                      },
                    ),
                    LogoutButton(onPressed: () async {
                      await authProvider.logout();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
