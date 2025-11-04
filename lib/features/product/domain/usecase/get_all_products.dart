import 'package:product_dashboard/features/product/domain/entites/product.entity.dart';


abstract class ProductRepository {
  Future<List<ProductEntity>> getAllProducts();
  Future<void> addProduct(ProductEntity product);
  Future<void> updateProduct(ProductEntity product);
  Future<void> deleteProduct(int id);
}
