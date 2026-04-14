import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screens.dart';
import 'providers/CartProvider.dart';
import 'providers/ProductProvider.dart';
import 'providers/CategoryProvider.dart';
import 'providers/WishlistProvider.dart';
import 'providers/ProfileProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  
  final token = prefs.getString('token');
  final isLoggedIn = token != null;

 runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CartProvider()),
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ChangeNotifierProvider(create: (_) => ProfileProvider()),
    ],
    child: MyApp(isLoggedIn: isLoggedIn),
  ),
);
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: isLoggedIn ? "/home" : "/login",

      routes: {
        "/login": (context) => const LoginScreen(),
        "/register": (context) => const RegisterScreen(),
        "/home": (context) => const HomeScreen(),
      },
    );
  }
}