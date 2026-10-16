import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/product.dart';

/// Ürün verilerini okur.
///
/// Ekstra paket (http vb.) kullanmadığımız için API'den alınan veri
/// assets/data/products.json dosyasına kaydedildi. Burada o dosyayı
/// okuyarak bir API çağrısını simüle ediyoruz.
class ProductRepository {
  static const _path = 'assets/data/products.json';

  Future<List<Product>> fetchProducts() async {
    // Gerçek bir ağ isteğindeki gecikmeyi taklit eder.
    await Future.delayed(const Duration(milliseconds: 600));

    final raw = await rootBundle.loadString(_path);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final list = decoded['data'] as List<dynamic>;

    return list
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
