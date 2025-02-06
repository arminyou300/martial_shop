import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SearchPage extends StatelessWidget {
  SearchPage({super.key});
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CupertinoSearchTextField(
          backgroundColor: Colors.grey.shade300,
          controller: searchController,
          keyboardType: TextInputType.text,
          autofocus: true,
          autocorrect: true,
          placeholder: 'Search in products',
        ),
      ),
      body: Column(),
    );
  }
}
