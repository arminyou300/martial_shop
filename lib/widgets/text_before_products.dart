import 'package:flutter/material.dart';

class TextBefore extends StatelessWidget {
  const TextBefore({super.key, required this.text});
  final String text ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontFamily: 'Ubuntu',
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
