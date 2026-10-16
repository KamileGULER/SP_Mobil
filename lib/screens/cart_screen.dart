import 'package:flutter/material.dart';

import '../data/cart.dart';
import '../theme/app_theme.dart';

/// Sepet sayfası (simülasyon): eklenen ürünleri listeler, silme ve
/// "Siparişi Tamamla" işlemlerini yapar.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _checkout(BuildContext context) async {
    final total = cart.total;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Sipariş alındı'),
        content: Text(
          'Toplam \$${total.toStringAsFixed(2)} tutarındaki siparişin '
          'alındı.\n\n(Bu bir simülasyondur, gerçek ödeme yapılmaz.)',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
    cart.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sepet')),
      body: ListenableBuilder(
        listenable: cart,
        builder: (context, _) {
          return Column(
            children: [
              Expanded(
                child: cart.isEmpty ? const _EmptyCart() : _buildList(),
              ),
              _buildSummary(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildList() {
    final items = cart.items;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final product = items[index];
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              product.image,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            product.name,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.tagline,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                product.price,
                style: const TextStyle(color: AppTheme.priceColor),
              ),
            ],
          ),
          trailing: IconButton(
            tooltip: 'Sepetten çıkar',
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () => cart.removeAt(index),
          ),
        );
      },
    );
  }

  Widget _buildSummary(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('${cart.count} ürün'),
                  ),
                  Text(
                    'Toplam: \$${cart.total.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: cart.isEmpty ? null : () => _checkout(context),
              child: const Text('Siparişi Tamamla'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.remove_shopping_cart_outlined,
              size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text(
            'Sepetin boş',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Alışverişe başlamak için ürün ekle',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
