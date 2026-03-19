import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:th4_e_commerce_app/providers/cart_provider.dart';
import 'package:th4_e_commerce_app/providers/order_provider.dart';
import 'package:th4_e_commerce_app/screens/home_screen.dart';

void main() {
  runApp(const MiniECommerceApp());
}

class MiniECommerceApp extends StatelessWidget {
  const MiniECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
        ChangeNotifierProvider<OrderProvider>(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Minimarket',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0076AA),
            elevation: 1,
            surfaceTintColor: Colors.transparent,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0096D6),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
