import 'package:product_dashboard/features/product/domain/entites/product.entity.dart';


class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.name,
    required super.category,
    required super.price,
    required super.inStock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'],
        name: json['name'],
        category: json['category'],
        price: (json['price'] as num).toDouble(),
        inStock: json['inStock'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'price': price,
        'inStock': inStock,
      };
}
