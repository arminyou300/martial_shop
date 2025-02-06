import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shopswift/api/firebase_api.dart';
import 'package:shopswift/firebase_options.dart';
import 'package:shopswift/models/shop.dart';
import 'package:shopswift/pages/cart_page.dart';
import 'package:shopswift/pages/category_page.dart';
import 'package:shopswift/pages/edit_profile_page.dart';
import 'package:shopswift/pages/login_page.dart';
import 'package:shopswift/pages/intro_page.dart';
import 'package:shopswift/pages/notifications_page.dart';
import 'package:shopswift/pages/orders.dart';
import 'package:shopswift/pages/profile_page.dart';
import 'package:shopswift/pages/register_page.dart';
import 'package:shopswift/pages/search_page.dart';
import 'package:shopswift/pages/shopping_page.dart';
import 'package:shopswift/pages/splash_page.dart';
import 'package:shopswift/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

int? initScreen;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();

  runApp(
    ChangeNotifierProvider(
      create: (context) => Shop(),
      child: Phoenix(
        child: const MyApp(),
      ),
    ),
  );
}
final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.transparent,
      home: const SplashPage(),
      theme: lightMode,
      initialRoute: '/splash_page',
      navigatorKey: navigatorKey,
      routes: {
        '/intro_page': (context) => const IntroPage(),
        '/profile_page': (context) => ProfilePage(),
        '/login_page': (context) => const LoginPage(),
        '/register_page': (context) => RegisterPage(),
        '/shopping_page': (context) => const ShoppingPage(),
        '/cart_page': (context) => const CartPage(),
        '/category_page': (context) => const CategoryPage(),
        '/splash_page': (context) => const SplashPage(),
        '/edit_profile': (context) => const EditProfile(),
        '/orders': (context) => const OrdersPage(),
        '/search': (context) => SearchPage(),
        '/notifications': (context) => const NotificationsPage(),
      },
    );
  }
}
