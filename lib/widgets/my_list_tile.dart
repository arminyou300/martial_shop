import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  const MyListTile(
      {super.key, required this.text, required this.icon, required this.onTap});

  final String text;
  final IconData icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.grey,
          size: 35,
        ),
        title: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Ubuntu',
            fontSize: 15,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
