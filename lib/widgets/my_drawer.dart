import 'package:shopswift/widgets/my_list_tile.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Icon(
                  Icons.shopping_bag,
                  size: 100,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              MyListTile(
                text: 'Profile',
                icon: Icons.person_outline_rounded,
                onTap: () {
                  Navigator.pushNamed(context, '/profile_page');
                },
              ),
              MyListTile(
                text: 'Favorites',
                icon: Icons.favorite_border_outlined,
                onTap: () {
                  Navigator.pushNamed(context, '/favorites_page');
                },
              ),
              MyListTile(
                text: 'Cart',
                icon: Icons.shopping_cart_outlined,
                onTap: () {
                  Navigator.pushNamed(context, '/cart_page');
                },
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: MyListTile(
              text: 'Log Out',
              icon: Icons.logout_rounded,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, '/intro_page', (route) => false);
              },
            ),
          ),

        ],
      ),
    );
  }
}
