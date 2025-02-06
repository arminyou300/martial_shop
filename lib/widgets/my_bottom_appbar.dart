import 'package:awesome_bottom_bar/tab_item.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyBottomNavbar extends StatelessWidget {
  MyBottomNavbar({
    super.key,
  });

  List<IconData> navIcons = [
    Icons.home_outlined,
    Icons.person_outlined,
    Icons.category_outlined,
    Icons.shopping_cart_outlined,
  ];

  List<String> navLabels = [
    'Home',
    'Account',
    'Categories',
    'Cart',
  ];

  @override
  Widget build(BuildContext context) {
    List<IconData> navIcons = [
      Icons.home_outlined,
      Icons.person_outlined,
      Icons.category_outlined,
      Icons.shopping_cart_outlined,
    ];

    return Container(
      height: 65,
      margin: const EdgeInsets.only(right: 24, left: 24, bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(29),
            blurRadius: 20,
            spreadRadius: 10,
          ),
        ],
      ),
      // child: Row(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: List.generate(navIcons.length, (index) {
      //     IconData icon = navIcons[index];
      //     bool isSelected = selectedIndex == index;
      //
      //     return Material(
      //       color: Colors.transparent,
      //       child: InkWell(
      //         onTap: () => onItemTapped(index),
      //         child: SingleChildScrollView(
      //           physics: const NeverScrollableScrollPhysics(),
      //           child: Column(
      //             children: [
      //               Container(
      //                 alignment: Alignment.center,
      //                 margin: const EdgeInsets.only(
      //                   top: 15,
      //                   bottom: 0,
      //                   left: 30,
      //                   right: 30,
      //                 ),
      //                 child: Icon(
      //                   icon,
      //                   color: isSelected ? Colors.blue : Colors.black,
      //                 ),
      //               ),
      //               Text(
      //                 index == 0?'Home':index == 1 ?'Profile': index == 2 ?'Categories': 'Cart',
      //                 style: TextStyle(
      //                   fontFamily: 'Ubuntu',
      //                   fontSize: 12,
      //                   fontWeight: FontWeight.bold,
      //                   color: isSelected ? Colors.blue : Colors.black,
      //                 ),
      //               ),
      //               const SizedBox(
      //                 height: 10,
      //               )
      //             ],
      //           ),
      //         ),
      //       ),
      //     );
      //   }),
      // ),
    );
  }
}
