import 'package:flutter/material.dart';

import '../data/cart.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/cart_button.dart';

/// Ürün detay sayfası. Gösterilecek ürünü Route Arguments ile alır.
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  void _addToCart(BuildContext context, Product product) {
    cart.add(product);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${product.name} sepete eklendi'),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    // Ana sayfada pushNamed(..., arguments: product) ile gönderilen ürün.
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Geri'),
        titleSpacing: 0,
        actions: const [CartButton(), SizedBox(width: 8)],
      ),
      body: ListView(
        children: [
          Container(
            height: 340,
            color: AppTheme.surfaceGrey,
            child: Hero(
              tag: 'product-${product.id}',
              child: Image.asset(product.image, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.tagline,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                Text(
                  product.price,
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppTheme.priceColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                const _SectionTitle('Açıklama'),
                Text(
                  product.description,
                  style: const TextStyle(height: 1.5),
                ),
                const SizedBox(height: 20),
                const _SectionTitle('Özellikler'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: product.specs.entries
                      .map((e) => _SpecChip(label: e.key, value: e.value))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton.icon(
            onPressed: () => _addToCart(context, product),
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Sepete Ekle'),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _SpecChip extends StatelessWidget {
  final String label;
  final String value;

  const _SpecChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE6E6E9)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
