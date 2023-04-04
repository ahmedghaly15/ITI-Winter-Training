import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_new_app/views/log_in_screen.dart';
import 'package:my_new_app/views/navbar/nav_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Checking if the user signed in before
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // in case he signed in before
            return const NavScreen();
          }
          // in case he didn't
          else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
