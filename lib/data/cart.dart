import 'package:flutter/foundation.dart';

import '../models/product.dart';

/// Sepet simülasyonu.
///
/// ChangeNotifier, Flutter'ın kendi içinde gelen basit bir state
/// yönetimi aracıdır (ekstra paket değildir). Sepet değiştiğinde
/// notifyListeners() çağrılır ve dinleyen ekranlar kendini yeniler.
class Cart extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  int get count => _items.length;

  bool get isEmpty => _items.isEmpty;

  double get total => _items.fold(0, (sum, p) => sum + p.priceValue);

  bool contains(Product product) => _items.any((p) => p.id == product.id);

  void add(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void removeAt(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

/// Uygulama genelinde tek bir sepet kullanılır.
final cart = Cart();
