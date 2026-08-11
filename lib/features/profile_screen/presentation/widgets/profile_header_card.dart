import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/auth_provider.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({Key? key}) : super(key: key);

  void _showAvatarSelectionSheet(BuildContext context, AuthProvider authProvider) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: const Color(0xFF1E1E24),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose an Avatar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  final avatarId = 'avatar-${index + 1}.png';
                  return GestureDetector(
                    onTap: () {
                      authProvider.updateAvatar(avatarId);
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/avatar/$avatarId'),
                      backgroundColor: Colors.grey[800],
                    ),
                  );
                },
              ),
            ],
          ),
          ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.userModel;
        final firstName = user?.firstName ?? 'User';
        final lastName = user?.lastName ?? '';
        final avatarId = user?.avatarId ?? 'avatar-1.png';
        final avatarPath = 'assets/avatar/$avatarId';

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF2C2C2C),
                Color(0xFF1E1E24),
              ],
            ),
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _showAvatarSelectionSheet(context, authProvider),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(avatarPath),
                        backgroundColor: Colors.grey[800],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                '$firstName $lastName'.trim(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
