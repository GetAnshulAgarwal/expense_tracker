import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_screen.dart' show DashboardScreen;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Controllers for Login
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  // Controllers for Sign Up
  final TextEditingController _signupEmailController = TextEditingController();
  final TextEditingController _signupPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();
  bool _signupAgreeToTerms = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login method
  void _login() async {
    if (_loginFormKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _loginEmailController.text,
          password: _loginPasswordController.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(user: userCredential.user!),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  // Sign Up method
  void _signUp() async {
    if (_signupFormKey.currentState!.validate() && _signupAgreeToTerms) {
      try {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(
              email: _signupEmailController.text,
              password: _signupPasswordController.text,
            );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(user: userCredential.user!),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  // Google Sign-In method (shared by both forms)
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(user: userCredential.user!),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Login & Sign Up
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Authentication'),
          bottom: const TabBar(
            tabs: [Tab(text: "Login"), Tab(text: "Sign Up")],
          ),
        ),
        body: TabBarView(
          children: [
            // Login Form
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _loginEmailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator:
                          (value) => value!.isEmpty ? 'Enter an email' : null,
                    ),
                    TextFormField(
                      controller: _loginPasswordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator:
                          (value) =>
                              value!.length < 6 ? 'Password too short' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.login),
                      label: const Text('Sign in with Google'),
                      onPressed: _signInWithGoogle,
                    ),
                  ],
                ),
              ),
            ),
            // Sign Up Form
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _signupFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _signupEmailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator:
                          (value) => value!.isEmpty ? 'Enter an email' : null,
                    ),
                    TextFormField(
                      controller: _signupPasswordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator:
                          (value) =>
                              value!.length < 6 ? 'Password too short' : null,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _signupAgreeToTerms,
                          onChanged: (value) {
                            setState(() {
                              _signupAgreeToTerms = value!;
                            });
                          },
                        ),
                        const Text('Agree to Terms & Privacy Policy'),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: _signUp,
                      child: const Text('Sign Up'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.login),
                      label: const Text('Sign up with Google'),
                      onPressed: _signInWithGoogle,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
