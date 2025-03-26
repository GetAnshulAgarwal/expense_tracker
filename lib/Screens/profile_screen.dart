import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
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
  final Color customColor = const Color(0xFF7F3DFF);

  @override
  void initState() {
    super.initState();
    // Use display name from user, or fallback to email
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
              onPressed: () {
                Navigator.of(context).pop();
              },
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
      // Navigate to login screen
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
      body: SafeArea(
        child: Column(
          children: [
            // Top Profile Info Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Profile Image with Refresh Button
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(_profileImageUrl),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.refresh, color: customColor),
                          onPressed: () {
                            setState(() {
                              _profileImageUrl = _generateRandomProfileImage();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Username and Edit Button
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Username',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          _currentUsername,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: customColor),
                    onPressed: _editUsername,
                  ),
                ],
              ),
            ),
            // Profile Options Menu
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildMenuItem(icon: Icons.account_circle, text: 'Account'),
                  _buildMenuItem(icon: Icons.settings, text: 'Settings'),
                  _buildMenuItem(icon: Icons.file_upload, text: 'Export Data'),
                  _buildMenuItem(
                    icon: Icons.logout,
                    text: 'Logout',
                    textColor: Colors.red,
                    onTap: _handleLogout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: 4,
        onTap: (index) {
          // Handle navigation for other indexes if needed.
          // For example, if the Home icon (index 0) is tapped:
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardScreen(user: widget.user),
              ),
            );
          }
          // Add additional navigation logic for other indexes if desired.
          print('Tapped index: $index');
        },
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: customColor),
        title: Text(text, style: TextStyle(color: textColor ?? Colors.black)),
        onTap: onTap,
      ),
    );
  }
}
