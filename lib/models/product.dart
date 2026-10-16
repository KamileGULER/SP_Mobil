/// Ürün veri modeli.
///
/// JSON'dan gelen her bir ürün bu sınıfa dönüştürülür (fromJson),
/// gerektiğinde tekrar JSON'a çevrilebilir (toJson).
class Product {
  final int id;
  final String name;
  final String tagline;
  final String description;
  final String price; // Örn: "$1,299"
  final String currency;
  final String image; // Asset yolu, örn: "assets/images/iphone.png"
  final Map<String, String> specs; // Ürüne göre değişen özellikler

  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.price,
    required this.currency,
    required this.image,
    required this.specs,
  });

  /// "$1,299" gibi bir metni hesaplamada kullanmak için 1299.0'a çevirir.
  double get priceValue =>
      double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

  /// Filtreleme için ürün adından basit bir kategori çıkarır.
  String get category {
    if (name.startsWith('iPhone')) return 'iPhone';
    if (name.startsWith('Mac') || name.startsWith('iMac')) return 'Mac';
    if (name.startsWith('iPad')) return 'iPad';
    if (name.contains('Watch')) return 'Watch';
    if (name.startsWith('AirPods') || name.startsWith('HomePod')) return 'Ses';
    return 'Diğer';
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawSpecs = json['specs'] as Map<String, dynamic>? ?? {};
    return Product(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      tagline: json['tagline'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: json['price'] as String? ?? '',
      currency: json['currency'] as String? ?? 'USD',
      image: json['image'] as String? ?? '',
      specs: rawSpecs.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'tagline': tagline,
        'description': description,
        'price': price,
        'currency': currency,
        'image': image,
        'specs': specs,
      };
}
