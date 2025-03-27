import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/bottom_navigation.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _currentUsername;
  late String _profileImageUrl;

  // Define your custom color (#7F3DFF)
  static const Color customColor = Color(0xFF7F3DFF);

  @override
  void initState() {
    super.initState();
    _currentUsername =
        widget.user.displayName ??
        widget.user.email?.split('@').first ??
        'User';
    _profileImageUrl = _generateRandomProfileImage();
  }

  String _generateRandomProfileImage() {
    return 'https://picsum.photos/seed/${Random().nextInt(1000)}/300/300';
  }

  void _editUsername() {
    final TextEditingController _usernameController = TextEditingController(
      text: _currentUsername,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Username'),
          content: TextField(
            controller: _usernameController,
            decoration: const InputDecoration(hintText: 'Enter new username'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  _currentUsername = _usernameController.text;
                });
                // Optional: Update user's display name in Firebase
                widget.user.updateDisplayName(_currentUsername);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logout failed: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: SafeArea(
        // Add top padding to create space from the top of the screen
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Column(
            children: [
              // Top Section: Avatar + Username + Edit Icon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(_profileImageUrl),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentUsername,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: customColor),
                      onPressed: _editUsername,
                    ),
                  ],
                ),
              ),
              // Add extra vertical space before the menu section
              const SizedBox(height: 40),
              // Profile Menu Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView(
                    children: [
                      _buildMenuCard(
                        icon: Icons.account_balance_wallet_rounded,
                        iconBgColor: customColor.withOpacity(0.1),
                        iconColor: customColor,
                        text: 'Account',
                      ),
                      _buildMenuCard(
                        icon: Icons.settings,
                        iconBgColor: customColor.withOpacity(0.1),
                        iconColor: customColor,
                        text: 'Settings',
                      ),
                      _buildMenuCard(
                        icon: Icons.file_upload,
                        iconBgColor: customColor.withOpacity(0.1),
                        iconColor: customColor,
                        text: 'Export Data',
                      ),
                      _buildMenuCard(
                        icon: Icons.logout,
                        iconBgColor: Colors.red.withOpacity(0.1),
                        iconColor: Colors.red,
                        text: 'Logout',
                        textColor: Colors.red,
                        onTap: _handleLogout,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: 4,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardScreen(user: widget.user),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String text,
    required Color iconBgColor,
    required Color iconColor,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return Container(
      height: 72, // Increased height for larger box
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Row(
          children: [
            const SizedBox(width: 12),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor ?? Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
