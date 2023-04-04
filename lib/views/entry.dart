import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'log_in_screen.dart';
import 'navbar/nav_screen.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  @override
  void initState() {
    nextPage();
    super.initState();
  }

  // check if the user passed LoginScreen or not
  nextPage() async {
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString('email');
    if (value == null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const NavScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check"),
        centerTitle: true,
      ),
      body: const Center(
        child: Icon(Icons.person_2_rounded),
      ),
    );
  }
}
