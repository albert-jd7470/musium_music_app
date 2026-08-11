import 'package:flutter/material.dart';
import 'package:musium_music_app/core/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.userModel;
        final firstName = user?.firstName ?? 'User';
        final avatarId = user?.avatarId ?? 'avatar-1.png';
        final avatarPath = 'assets/avatar/$avatarId';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end ,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/logo/applogo.png',
                    width: 42,
                    height: 42,
                  ),
                   SizedBox(width: 5),
                  Image.asset(
                    'assets/logo/app_name.png',
                    height: 24, // Adjust height as needed
                    color: const Color(0xFF1ED760), // Tint the image green
                  ),
                ],
              ),
              const Spacer(),
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'logout') {
                    await authProvider.logout();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ],
                child: CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage(avatarPath),
                  backgroundColor: Colors.grey[800],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
