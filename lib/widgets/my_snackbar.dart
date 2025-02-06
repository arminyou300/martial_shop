import 'package:flutter/material.dart';

void MySnackbar(BuildContext context,String text){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      behavior: SnackBarBehavior.floating,
      content: Text(
        text,
      ),
    ),
  );
}