// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopswift/constants.dart';
import 'package:shopswift/widgets/button_filled.dart';
import 'package:shopswift/widgets/my_snackbar.dart';
import 'package:shopswift/widgets/pretty_textfield.dart';
import 'package:shopswift/widgets/social_login_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  bool showPassword = true;
  bool isLoading = false;

  void onLoginPressed() async {}

  final bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 200),
            Center(
              child: Column(
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  // My Own TextField
                  PrettyTextField(
                    controller: emailController,
                    errorText: 'Email is not correct',
                    hintText: 'Email *',
                    fieldColor: Colors.black,
                    hiddenText: false,
                    isEmail: true,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  // My Own TextField
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 300,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: TextField(
                              controller: passwordController,
                              textAlign: TextAlign.left,
                              textInputAction: TextInputAction.done,
                              obscureText: showPassword,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                errorText: _validate
                                    ? 'Password is not correct'
                                    : null,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                  icon: Icon(
                                    showPassword == true
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                                counterText: "",
                                enabledBorder: InputBorder.none,
                                border: InputBorder.none,
                                hintText: 'Password *',
                                hintStyle: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              onTapOutside: (event) =>
                                  FocusScope.of(context).requestFocus(
                                FocusNode(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register_page');
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Login Button
                  ButtonFilled(
                    buttonWidth: 150,
                    buttonHeight: 40,
                    buttonBackgroundColor: Colors.white,
                    buttonBorderRadius: 20,
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(
                              context, '/shopping_page');
                        }
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          isLoading = false;
                        });
                        if (e.code == 'user-not-found') {
                          MySnackbar(context, 'No user found with that email.');
                        } else if (e.code == 'wrong-password') {
                          MySnackbar(context,
                              'Wrong password provided for that user.');
                        } else if (e.code == 'invalid-credential') {
                          MySnackbar(context,
                              'Cannot find user with these credentials.');
                        } else if (e.code == 'too-many-requests') {
                          MySnackbar(context,
                              'Too many attempts. Please try again later');
                        } 
                      }
                    },
                    child: isLoading == false
                        ? const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Ubuntu',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const SizedBox(
                            height: 20,
                            width: 20,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Text Button
                  const SizedBox(
                    height: 90,
                  ),
                  // Social Login Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialLoginButton(
                        buttonWidth: 50,
                        buttonHeight: 50,
                        buttonColor: Colors.white,
                        buttonBorderRadius: 15,
                        imageScale: 35,
                        assetImageLocation: 'assets/images/google.png',
                        onTap: () {},
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      SocialLoginButton(
                          buttonWidth: 50,
                          buttonHeight: 50,
                          buttonColor: Colors.white,
                          buttonBorderRadius: 15,
                          imageScale: 15,
                          assetImageLocation: 'assets/images/facebook.png',
                          onTap: () {}),
                      const SizedBox(
                        width: 30,
                      ),
                      SocialLoginButton(
                        buttonWidth: 50,
                        buttonHeight: 50,
                        buttonColor: Colors.white,
                        buttonBorderRadius: 15,
                        imageScale: 20,
                        assetImageLocation: 'assets/images/apple.png',
                        onTap: () {},
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      SocialLoginButton(
                        buttonWidth: 50,
                        buttonHeight: 50,
                        buttonColor: Colors.white,
                        buttonBorderRadius: 15,
                        imageScale: 30,
                        assetImageLocation: 'assets/images/email.png',
                        onTap: () {
                          Navigator.pushNamed(context, '/register_page');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Text(
                    'All rights reserved to MartialShop©',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
