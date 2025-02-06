import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shopswift/widgets/my_bottom_appbar.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> userSignOut() async {
    await FirebaseAuth.instance.signOut();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user?.reload();
  }
  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: GNav(
            padding: const EdgeInsets.all(10),
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
            tabs: const [
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
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.blue,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${user?.displayName}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Ubuntu',
                        fontSize: 20,
                      ),
                    ),
                    if (user!.email!.isNotEmpty)
                      Text(
                        '${user?.email}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Ubuntu',
                          fontSize: 10,
                        ),
                      )
                    else if (user!.phoneNumber!.isNotEmpty)
                      Text(
                        '${user?.phoneNumber}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Ubuntu',
                          fontSize: 20,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 50,),
          user?.emailVerified == false? const Text('Your email is not verified'):
          const SizedBox(height: 50,),

          const SizedBox(
            height: 150,
          ),
          Flexible(
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          switch (index) {
                            case 0:
                              {
                                Navigator.pushNamed(context, '/edit_profile');
                              }
                            case 1:
                              {
                                Navigator.pushNamed(context, '/orders');
                              }
                            case 2:
                              {
                                Navigator.pushNamed(context, '/favorites');
                              }
                            case 3:
                              {
                                Navigator.pushNamed(context, '/addresses');
                              }
                            case 4:
                              {
                                Navigator.pushNamed(context, '/notifications');
                              }
                            case 5:
                              {
                                userSignOut();
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/intro_page',
                                  ModalRoute.withName('/intro_page'),
                                );
                              }
                          }
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (index == 0)
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.person_outline_rounded,
                                      ),
                                    ),
                                    const Text(
                                      'Profile',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Ubuntu',
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              if (index == 1)
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.favorite_border_outlined,
                                      ),
                                    ),
                                    const Text(
                                      'Favorites',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Ubuntu',
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              if (index == 2)
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.favorite_border_outlined,
                                      ),
                                    ),
                                    const Text(
                                      'Favorites',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Ubuntu',
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              if (index == 3)
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.location_on_outlined,
                                      ),
                                    ),
                                    const Text(
                                      'Addresses',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Ubuntu',
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              if (index == 4)
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/notifications');
                                      },
                                      icon: const Icon(
                                        Icons.notifications_none_rounded,
                                      )
                                    ),
                                    const Text(
                                      'Notifications',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Ubuntu',
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              if (index == 5)
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        userSignOut();
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          '/intro_page',
                                          ModalRoute.withName('/intro_page'),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.logout_rounded,
                                      ),
                                    ),
                                    const Text(
                                      'Log Out',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Ubuntu',
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        color: Colors.white,
                        endIndent: 30,
                        indent: 30,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
