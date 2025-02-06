import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shopswift/constants.dart';
import 'package:shopswift/models/shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopswift/pages/splash_page.dart';
import 'package:shopswift/widgets/my_slider.dart';
import 'package:shopswift/widgets/see_all_buttons.dart';
import 'package:shopswift/widgets/text_before_products.dart';
import 'package:shopswift/widgets/my_stream_builder.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  // final String ufcSparring = 'dwdgcfZRuQjBP3HzrGru';
  final bool _refreshIndicatorKey = false;
  User? user = FirebaseAuth.instance.currentUser;
  bool isSearching = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user?.reload();
  }

  @override
  Widget build(BuildContext context) {
    // Access Products In Shop
    final boxingProducts = context.watch<Shop>().boxing;
    final mmaProducts = context.watch<Shop>().mma;
    final bagsProducts = context.watch<Shop>().bags;
    final otherProducts = context.watch<Shop>().other;
    final cart = context.watch<Shop>().cart;

    Future<void> onRefresh() async {
      await Future.delayed(
        const Duration(seconds: 1),
      );
      user?.reload();
      if (context.mounted) {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const SplashPage(),
          ),
        );
      }
    }

    String placeHolder = 'Search in Martial Shop';
    int selectedIndex = 0;

    void onItemTapped(int index) {


      // Navigation logic here
      switch (index) {
        case 0:
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            ModalRoute.withName('/'),
          );
          break;
        case 1:
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/profile_page',
            ModalRoute.withName('/'),
          );
          break;
        case 2:
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/category_page',
            ModalRoute.withName('/'),
          );
          break;
        case 3:
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/cart_page',
            ModalRoute.withName('/'),
          );
          break;
      }
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: GNav(
            padding: EdgeInsets.all(10),
            color: Colors.black,
            backgroundColor: Colors.white,
            activeColor: Colors.blue,
            gap: 8,
            tabActiveBorder: Border.all(
              color: Colors.blue
            ),
            onTabChange: (index) {
              onItemTapped(index);
            },
            tabs: [
              GButton(
                icon: Icons.home_outlined,
                text: 'Home',
              ),
              GButton(
                icon: Icons.person_outline_rounded,
                text: 'Profile',

              ),
              GButton(
                icon: Icons.category_outlined,
                text: 'Categories',

              ),
              GButton(
                icon: Icons.shopping_cart_outlined,
                text: 'Cart',

              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => onRefresh(),
              color: Theme.of(context).colorScheme.inversePrimary,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoSearchTextField(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      placeholder: placeHolder,
                      onTap: () => Navigator.pushNamedAndRemoveUntil(
                          context, '/search', ModalRoute.withName('/')),
                    ),
                  ),
                  const MySlider(),
                  const SizedBox(
                    height: 10,
                  ),
                  // Boxing Products
                  const TextBefore(
                    text: 'Boxing Products',
                  ),
                  const SizedBox(
                    height: 300,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // Product 1
                          MyStreamBuilder(
                            productUID: venomGloves,
                          ),
                          // Product 2
                          MyStreamBuilder(
                            productUID: swtSuit,
                          ),
                          // Product 3
                          MyStreamBuilder(
                            productUID: everlastGloves,
                          ),
                          // See All Button
                          SeeAllButton()
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const TextBefore(
                    text: 'MMA Products',
                  ),
                  // MMA Products
                  SizedBox(
                    height: 300,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const MyStreamBuilder(
                            productUID: ufcGloves,
                          ),
                          const MyStreamBuilder(
                            productUID: ufcMitts,
                          ),
                          const MyStreamBuilder(
                            productUID: ufcSparring,
                          ),
                          SizedBox(
                            height: 320,
                            width: 170,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(25),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  const Text(
                                    'See All',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                        width: 2,
                                      ),
                                    ),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.arrow_forward_ios,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const TextBefore(
                    text: 'Punching Bags',
                  ),
                  // Punching Bags
                  SizedBox(
                    height: 300,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const MyStreamBuilder(
                            productUID: everlastHeavyBag,
                          ),
                          const MyStreamBuilder(
                            productUID: punchingDummy,
                          ),
                          const MyStreamBuilder(
                            productUID: speedBag,
                          ),
                          SizedBox(
                            height: 320,
                            width: 170,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(25),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  const Text(
                                    'See All',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                        width: 2,
                                      ),
                                    ),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.arrow_forward_ios,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const TextBefore(
                    text: 'Other Products',
                  ),
                  // Other Products
                  SizedBox(
                    height: 300,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const MyStreamBuilder(
                            productUID: ufcWatch,
                          ),
                          const MyStreamBuilder(
                            productUID: longSleeve,
                          ),
                          const MyStreamBuilder(
                            productUID: '04mtsK7E1imUOu7iV6mm',
                          ),
                          SizedBox(
                            height: 320,
                            width: 170,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(25),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  const Text(
                                    'See All',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                        width: 2,
                                      ),
                                    ),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.arrow_forward_ios,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 110,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
