import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key, required this.body});

  final Widget body;

  openDrawer(BuildContext context){
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      physics: const BouncingScrollPhysics(),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.inversePrimary,
            leading: IconButton(
              icon: const Icon(Icons.menu_rounded, color: Colors.black),
              onPressed: () => openDrawer(context),
            ),
            title: const Text("TigerPaw"),
            centerTitle: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            expandedHeight: 50,
            floating: true,
            snap: true,
            actions: [
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/cart_page'),
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                ),
              )
            ],
          ),
        ];
      },
      body: body,
    );
  }
}
