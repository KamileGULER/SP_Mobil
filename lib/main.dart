import 'package:flutter/material.dart';

import 'screens/cart_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MiniKatalogApp());
}

/// Uygulamadaki sayfa adları (Named Routes).
class AppRoutes {
  static const home = '/';
  static const detail = '/detail';
  static const cart = '/cart';
}

class MiniKatalogApp extends StatelessWidget {
  const MiniKatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Katalog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => const HomeScreen(),
        // Detay sayfası, açılırken Route Arguments ile bir Product alır.
        AppRoutes.detail: (context) => const ProductDetailScreen(),
        AppRoutes.cart: (context) => const CartScreen(),
      },
    );
  }
}
