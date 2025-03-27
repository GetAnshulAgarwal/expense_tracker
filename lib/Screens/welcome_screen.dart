import 'package:assignment_cs/Screens/signup_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Purple background from your design
      backgroundColor: const Color(0xFF6C4DE5),
      body: Stack(
        children: [
          // Swirl at the top-right
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/images/recordedright.png',
              width: 300,
              height: 300,
            ),
          ),

          // Swirl at the bottom-left
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/images/recordedbottom.png',
              width: 300,
              height: 300,
            ),
          ),
          SizedBox(height: 15),

          // Top-center CipherX swirl/logo
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Image.asset(
                'assets/images/cipherx_logo.png', // Your swirl/logo
                height: 80, // Adjust as needed
              ),
            ),
          ),

          // Bottom-left text (Welcome to ... CipherX text image)
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 40.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // “Welcome to” text
                  const Text(
                    'Welcome to',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  // CipherX as an image
                  Image.asset(
                    'assets/images/CipherX.png', // Your stylized "CipherX" text
                    height: 30, // Adjust as needed
                  ),
                  const SizedBox(height: 45),
                  // Subtitle
                  const Text(
                    'The best way to track your expenses.',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Bottom-right arrow button
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0, bottom: 110.0),
              child: GestureDetector(
                onTap: () {
                  // Navigate to SignUpScreen on tap
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AuthScreen()),
                  );
                },
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEDE1E1BF),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
