import 'package:flutter/material.dart';

import '../data/cart.dart';
import '../main.dart';

/// Üzerinde sepetteki ürün sayısını gösteren sepet ikonu.
class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder: sepet her değiştiğinde sadece bu ikonu yeniden çizer.
    return ListenableBuilder(
      listenable: cart,
      builder: (context, _) => IconButton(
        tooltip: 'Sepet',
        onPressed: () {
          // Sepete giderken açık bir bildirim varsa kapat.
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.pushNamed(context, AppRoutes.cart);
        },
        icon: Badge(
          isLabelVisible: !cart.isEmpty,
          label: Text('${cart.count}'),
          child: const Icon(Icons.shopping_bag_outlined),
        ),
      ),
    );
  }
}
