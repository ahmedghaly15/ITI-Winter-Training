import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../log_in_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String email = "";

  getEmail() async {
    // final prefs = await SharedPreferences.getInstance();
    // email = prefs.getString("email") ?? "--";
    // setState(() {});
  }

  final user = FirebaseAuth.instance.currentUser!;

  // @override
  // void initState() {
  //   super.initState();
  //   getEmail();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text(
        user.email!,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      )),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () async {
            // final prefs = await SharedPreferences.getInstance();
            // prefs.clear();
            FirebaseAuth.instance.signOut();

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          child: const Icon(
            Icons.logout,
            color: Colors.white,
          )),
    );
  }
}
