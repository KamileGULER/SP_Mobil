import 'package:flutter/material.dart';

import '../data/product_repository.dart';
import '../main.dart';
import '../models/product.dart';
import '../widgets/cart_button.dart';
import '../widgets/product_card.dart';

/// Ana sayfa: başlık, arama, banner, kategori filtresi ve ürün grid'i.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _categories = ['Tümü', 'iPhone', 'Mac', 'iPad', 'Watch', 'Ses'];

  final _repository = ProductRepository();
  late final Future<List<Product>> _productsFuture;

  String _query = '';
  String _selectedCategory = 'Tümü';

  @override
  void initState() {
    super.initState();
    _productsFuture = _repository.fetchProducts();
  }

  /// Arama metnine ve seçili kategoriye göre listeyi süzer.
  List<Product> _filter(List<Product> products) {
    final q = _query.trim().toLowerCase();
    return products.where((p) {
      final matchesCategory =
          _selectedCategory == 'Tümü' || p.category == _selectedCategory;
      final matchesQuery = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.tagline.toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Keşfet',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
            ),
            Text(
              'Sana en uygun cihazı bul.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: const [CartButton(), SizedBox(width: 8)],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ürünler yüklenemedi: ${snapshot.error}'));
          }

          final products = _filter(snapshot.data!);

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: [
              TextField(
                onChanged: (value) => setState(() => _query = value),
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: 'Ürün ara',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset('assets/images/banner.png'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final selected = category == _selectedCategory;
                    return ChoiceChip(
                      label: Text(category),
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      selected: selected,
                      onSelected: (_) =>
                          setState(() => _selectedCategory = category),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              if (products.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(child: Text('Aramana uygun ürün bulunamadı.')),
                )
              else
                GridView.builder(
                  // Dıştaki ListView ile birlikte kaydırılması için:
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      // Route Arguments: seçilen ürünü detay sayfasına gönderiyoruz.
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.detail,
                        arguments: product,
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
