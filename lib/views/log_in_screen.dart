import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import 'package:shared_preferences/shared_preferences.dart';

import 'navbar/nav_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

enum AuthMode { signUp, login }

class _LoginScreenState extends State<LoginScreen> {
  AuthMode authMode = AuthMode.login;

  void _switchAuthMode() {
    if (authMode == AuthMode.login) {
      setState(() {
        authMode = AuthMode.signUp;
      });
    } else {
      setState(() {
        authMode = AuthMode.login;
      });
    }
  }

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  bool isPassVisible = true;
  String email = "";
  String password = "";
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 244, 244, 244),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: double.infinity,
                  height: authMode == AuthMode.login ? 370 : 400,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          buildTextField(
                              usernameController,
                              "Email",
                              false,
                              const Icon(Icons.email_rounded),
                              (val) {
                                if (val!.isEmpty || !val.contains("@")) {
                                  return "Ivalid Email";
                                }
                                return null;
                              },
                              TextInputType.emailAddress,
                              (val) {
                                email = val!;
                              }),
                          const SizedBox(height: 20),
                          buildTextField(
                            passwordController,
                            "Password",
                            isPassVisible,
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isPassVisible = !isPassVisible;
                                });
                              },
                              icon: Icon(isPassVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                            (val) {
                              if (val!.isEmpty || val.length < 7) {
                                return "Password is too short";
                              }
                              return null;
                            },
                            TextInputType.visiblePassword,
                            null,
                          ),
                          const SizedBox(height: 20),
                          if (authMode == AuthMode.signUp)
                            buildTextField(
                              confirmPassController,
                              "Confirm Password",
                              isPassVisible,
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isPassVisible = !isPassVisible;
                                  });
                                },
                                icon: Icon(isPassVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                              (val) {
                                if (val!.isEmpty || val.length < 7) {
                                  return "Password is too short";
                                }
                                return null;
                              },
                              TextInputType.visiblePassword,
                              null,
                            ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (authMode == AuthMode.login) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      });

                                  try {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: usernameController.text,
                                            password: passwordController.text);
                                    // final prefs =
                                    //     await SharedPreferences.getInstance();
                                    // await prefs.setString('email', email);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NavScreen()),
                                    );
                                  } on FirebaseAuthException catch (e) {
                                    Navigator.pop(context);
                                    if (e.code == 'user-not-found') {
                                      wrongEmail();
                                    } else if (e.code == 'wrong-password') {
                                      wrongPass();
                                    }
                                    SnackBar snackBar = SnackBar(
                                      content:
                                          Text("password and email not valid"),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                } else if (authMode == AuthMode.signUp) {
                                  try {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: usernameController.text,
                                            password:
                                                confirmPassController.text);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NavScreen()),
                                    );
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'weak-password') {
                                      showMyDialog("Password is too weak");
                                    } else if (e.code ==
                                        'email-already-in-use') {
                                      showMyDialog("Already exists Account");
                                    }
                                  }
                                }
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.purple),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              textStyle: MaterialStateProperty.all(
                                const TextStyle(
                                  fontFamily: 'OpenSans',
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              elevation: MaterialStateProperty.all(8.0),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 15.0),
                              ),
                            ),
                            child: Text(
                              authMode == AuthMode.login ? "Log in" : "Sign up",
                              style: const TextStyle(
                                fontSize: 25,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(authMode == AuthMode.login
                                  ? "Don't have an account?"
                                  : "Already have an account?"),
                              TextButton(
                                onPressed: _switchAuthMode,
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 4.0)),
                                  textStyle: MaterialStateProperty.all(
                                    const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                child: Text(
                                  authMode == AuthMode.login
                                      ? "Sign up"
                                      : "Sign in",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void wrongEmail() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Incorrect Email"),
          );
        });
  }

  void showMyDialog(String error) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(error),
          );
        });
  }

  void wrongPass() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Incorrect Password"),
          );
        });
  }

  TextFormField buildTextField(
    TextEditingController? controller,
    String label,
    bool obsecure,
    Widget? icon,
    String? Function(String?)? validating,
    TextInputType keyboardType,
    Function(String?)? onChanged,
  ) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      decoration: InputDecoration(
        suffixIconColor: Colors.purple,
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 15,
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w600,
          color: Colors.purple,
        ),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor)),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon: icon,
        contentPadding: const EdgeInsets.only(left: 10.0),
      ),
      keyboardType: keyboardType,
      obscureText: obsecure,
      validator: validating,
      obscuringCharacter: '•',
    );
  }
}
