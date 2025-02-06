import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopswift/constants.dart';
import 'package:shopswift/widgets/button_filled.dart';
import 'package:shopswift/widgets/pretty_textfield.dart';
import 'package:shopswift/widgets/social_login_button.dart';
import 'package:flutter/material.dart';
import 'package:shopswift/widgets/my_snackbar.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool showPassword = true;
  bool isLoading = false;

  bool _validate = false;
  TextEditingController nickNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  void onRegisterPressed(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final CollectionReference firebaseFirestore =
        FirebaseFirestore.instance.collection('users');
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      User? user = userCredential.user;
      user?.updateDisplayName(nickNameController.text);
      var data = {
        'Email': emailController.text,
        'UID': user?.uid,
      };
      user?.sendEmailVerification();
      firebaseFirestore
          .doc(emailController.text)
          .set(data)
          .then(
            (value) => Navigator.pushNamedAndRemoveUntil(
              context,
              '/shopping_page',
              ModalRoute.withName('/'),
            ),
          )
          .catchError(
            (error) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 10,
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                behavior: SnackBarBehavior.floating,
                content: Text(
                  'Unable to connect to the database.\nPlease try again.',
                ),
              ),
            ),
          );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (nickNameController.text.length < 5) {
        MySnackbar(context, 'username should be more than 6 letters.');
      }else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 10,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            behavior: SnackBarBehavior.floating,
            content: const Text(
              'An account already exists with that email.',
            ),
            action: SnackBarAction(
              label: 'login',
              onPressed: () {
                Navigator.pushNamed(context, '/login_page');
              },
            ),
          ),
        );
      } else if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 10,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            behavior: SnackBarBehavior.floating,
            content: const Text(
              'Password is so weak!',
            ),
          ),
        );
      }
      else if (e.code == 'invalid-email'){
        MySnackbar(context, 'Email is not valid.');
      }
      else if (e.code == 'channel-error'){
        MySnackbar(context, 'Please fill every fields.');
      }
      print(e);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 150),
            Center(
              child: Column(
                children: [
                  const Text(
                    'Register Account',
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
                  PrettyTextField(
                    controller: nickNameController,
                    errorText: "",
                    hintText: "Username *",
                    fieldColor: Colors.black,
                    hiddenText: false,
                    isEmail: false,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  PrettyTextField(
                    controller: emailController,
                    errorText: "Email format is not correct",
                    hintText: "Email *",
                    fieldColor: Colors.black,
                    hiddenText: false,
                    isEmail: true,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
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
                            errorText:
                                _validate ? 'Password is not correct' : null,
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
                          style: TextStyle(
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

                  const SizedBox(
                    height: 50,
                  ),
                  ButtonFilled(
                    buttonWidth: 150,
                    buttonHeight: 40,
                    buttonBackgroundColor: Colors.white,
                    buttonBorderRadius: 20,
                    onTap: () {
                      onRegisterPressed(context);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login_page');
                        },
                        child: const Text(
                          "Login!",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
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
                        imageScale: 20,
                        assetImageLocation: 'assets/images/apple.png',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
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
