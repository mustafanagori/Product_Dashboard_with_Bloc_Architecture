class ProductEntity {
  final int id;
  final String name;
  final String category;
  final double price;
  final bool inStock;

  ProductEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.inStock,
  });
}
