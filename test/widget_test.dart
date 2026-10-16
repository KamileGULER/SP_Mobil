import 'package:flutter_test/flutter_test.dart';

import 'package:mini_katalog/data/cart.dart';
import 'package:mini_katalog/main.dart';
import 'package:mini_katalog/models/product.dart';

void main() {
  test('Product fromJson/toJson ve fiyat dönüşümü', () {
    final product = Product.fromJson({
      'id': 6,
      'name': 'MacBook Pro 16"',
      'tagline': 'Mind-blowing.',
      'description': 'desc',
      'price': r'$2,499',
      'currency': 'USD',
      'image': 'assets/images/macbook.png',
      'specs': {'chip': 'M3 Max'},
    });

    expect(product.priceValue, 2499);
    expect(product.category, 'Mac');
    expect(product.toJson()['specs'], {'chip': 'M3 Max'});
  });

  test('Sepete ekleme ve toplam', () {
    final c = Cart();
    const p = Product(
      id: 1,
      name: 'iPhone 15',
      tagline: '',
      description: '',
      price: r'$799',
      currency: 'USD',
      image: '',
      specs: {},
    );
    c.add(p);
    c.add(p);
    expect(c.count, 2);
    expect(c.total, 1598);
    c.removeAt(0);
    expect(c.count, 1);
  });

  testWidgets('Ana sayfa ürünleri yükler', (tester) async {
    await tester.pumpWidget(const MiniKatalogApp());
    expect(find.text('Keşfet'), findsOneWidget);

    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 800)));
    await tester.pumpAndSettle();
    expect(find.text('iPhone 15 Pro'), findsOneWidget);
  });
}
