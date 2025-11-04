import 'package:product_dashboard/features/product/domain/entites/product.entity.dart';
import 'package:product_dashboard/features/product/domain/repository/product_repository.dart';
import 'package:product_dashboard/features/product/model/product_model.dart';

import '../datasources/product_local_data_source.dart';



class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource dataSource;

  List<ProductModel> _products = [];

  ProductRepositoryImpl(this.dataSource);

  @override
  Future<List<ProductEntity>> getAllProducts() async {
    if (_products.isEmpty) {
      _products = await dataSource.fetchProducts();
    }
    return _products;
  }

  @override
  Future<void> addProduct(ProductEntity product) async {
    final model = ProductModel(
      id: product.id,
      name: product.name,
      category: product.category,
      price: product.price,
      inStock: product.inStock,
    );
    _products.add(model);
  }

  @override
  Future<void> updateProduct(ProductEntity product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = ProductModel(
        id: product.id,
        name: product.name,
        category: product.category,
        price: product.price,
        inStock: product.inStock,
      );
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    _products.removeWhere((p) => p.id == id);
  }
}
