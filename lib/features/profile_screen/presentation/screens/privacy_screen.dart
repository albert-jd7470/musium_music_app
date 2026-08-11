import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E24),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Musium Privacy Policy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Last Updated: August 2026',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('1. Information We Collect'),
              _buildParagraph(
                'When you use Musium, we collect information you provide directly to us (such as your name, email address, and profile picture). We also collect data regarding your listening habits, search history, and device information to provide a better streaming experience.',
              ),
              _buildSectionTitle('2. How We Use Your Information'),
              _buildParagraph(
                'We use the information we collect to:\n'
                '• Provide, maintain, and improve our services\n'
                '• Personalize your music recommendations\n'
                '• Sync your account data across devices\n'
                '• Communicate with you about updates and offers',
              ),
              _buildSectionTitle('3. Data Storage & Security'),
              _buildParagraph(
                'Your personal data and preferences are securely stored using Google Firebase. We implement industry-standard security measures to protect your account against unauthorized access or data breaches.',
              ),
              _buildSectionTitle('4. Third-Party Services'),
              _buildParagraph(
                'We may use third-party services (such as analytics providers) to better understand how our app is used. These third parties may have access to some of your data, but they are bound by strict confidentiality agreements.',
              ),
              _buildSectionTitle('5. Your Rights'),
              _buildParagraph(
                'You have the right to access, update, or delete your personal information at any time. You can manage your preferences directly from the settings page or by contacting our support team.',
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  '© 2026 JD. All rights reserved.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1ED760),
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.white70,
        height: 1.6,
      ),
    );
  }
}
