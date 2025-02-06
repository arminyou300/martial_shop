import 'package:shopswift/constants.dart';
import 'package:shopswift/widgets/button_filled.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          const SizedBox(height: 250),
          Center(
            child: Column(
              children: [
                const Text(
                  'TigerPaw',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sports_martial_arts,
                      color: Colors.black,
                      size: 100,
                    ),
                    Icon(
                      Icons.sports_mma,
                      color: Colors.black,
                      size: 100,
                    ),
                  ],
                ),
                const Text(
                  'A shop for martial artists',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 150,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ButtonFilled(
                      buttonWidth: 150,
                      buttonHeight: 40,
                      buttonBackgroundColor: Colors.white,
                      buttonBorderRadius: 15,
                      onTap: () {
                        Navigator.pushNamed(context, '/login_page');
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Ubuntu',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ButtonFilled(
                      buttonWidth: 150,
                      buttonHeight: 40,
                      buttonBackgroundColor: Colors.white,
                      buttonBorderRadius: 15,
                      onTap: () {
                        Navigator.pushNamed(context, '/register_page');
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Ubuntu',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

tapped() {}
