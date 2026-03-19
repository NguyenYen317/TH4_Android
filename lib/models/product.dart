class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final List<String> images;
  final double rating;
  final int ratingCount;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.images = const [],
    required this.rating,
    required this.ratingCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final ratingJson = json['rating'];
    final rateValue = ratingJson is Map ? (ratingJson['rate'] ?? 0) : 0;
    final countValue = ratingJson is Map ? (ratingJson['count'] ?? 0) : 0;

    final imageValue = json['image']?.toString() ?? '';
    final rawImages = json['images'];
    final images = rawImages is List
        ? rawImages
            .map((e) => e.toString())
            .where((e) => e.isNotEmpty)
            .toList()
        : <String>[];
    final resolvedImages = images.isNotEmpty
        ? images
        : (imageValue.isNotEmpty ? [imageValue] : <String>[]);

    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      image: imageValue,
      images: resolvedImages,
      rating: (rateValue as num?)?.toDouble() ?? 0.0,
      ratingCount: (countValue as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'images': images,
      'rating': {
        'rate': rating,
        'count': ratingCount,
      },
    };
  }
}
