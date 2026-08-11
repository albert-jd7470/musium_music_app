import 'package:flutter/material.dart';
import 'package:musium_music_app/core/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class MainHeader extends StatelessWidget {
  final String title;

  const MainHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.userModel;
        final avatarId = user?.avatarId ?? 'avatar-1.png';
        final avatarPath = 'assets/avatar/$avatarId';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.music_note,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'HELLO',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {},
              ),
              const SizedBox(width: 8.0),
              GestureDetector(
                onTap: () {
                  context.go('/profile');
                },
                child: CircleAvatar(
                  radius: 18,
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
