import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_dashboard/features/product/domain/entites/product.entity.dart';
import 'package:product_dashboard/features/product/domain/repository/product_repository.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;

  List<ProductEntity> _allProducts = [];
  bool _ascending = true;
  String _sortColumn = 'id';

  ProductCubit(this.repository) : super(ProductInitial());

  void fetchProducts() async {
    emit(ProductLoading());
    _allProducts = await repository.getAllProducts();
    emit(ProductLoaded(_allProducts));
  }

  void addProduct(ProductEntity product) async {
    await repository.addProduct(product);
    fetchProducts();
    emit(ProductActionSuccess('Product added successfully'));
  }

  void updateProduct(ProductEntity product) async {
    await repository.updateProduct(product);
    fetchProducts();
    emit(ProductActionSuccess('Product updated successfully'));
  }

  void deleteProduct(int id) async {
    await repository.deleteProduct(id);
    fetchProducts();
    emit(ProductActionSuccess('Product deleted successfully'));
  }

  //  sorting 
 void sortProducts(String column) {
  if (_sortColumn == column) {
    _ascending = !_ascending;
  } else {
    _sortColumn = column;
    _ascending = true;
  }

  _allProducts.sort((a, b) {
    dynamic valA;
    dynamic valB;

    switch (column) {
      case 'id':
        valA = a.id;
        valB = b.id;
        break;
      case 'name':
        valA = a.name.toLowerCase();
        valB = b.name.toLowerCase();
        break;
      case 'category':
        valA = a.category.toLowerCase();
        valB = b.category.toLowerCase();
        break;
      case 'price':
        valA = a.price;
        valB = b.price;
        break;
      case 'inStock':
        valA = a.inStock ? 1 : 0;
        valB = b.inStock ? 1 : 0;
        break;
      default:
        valA = a.id;
        valB = b.id;
    }

    final compare = Comparable.compare(valA, valB);
    return _ascending ? compare : -compare;
  });

  emit(ProductLoaded(List.from(_allProducts)));
}

  //filter 
  void filterProducts(String text, String category, String availability) {
    List<ProductEntity> filtered = _allProducts.where((p) {
      final matchesText =
          p.name.toLowerCase().contains(text.toLowerCase()) ||
          p.category.toLowerCase().contains(text.toLowerCase());
      final matchesCategory =
          category == 'All' ? true : p.category == category;
      final matchesAvailability = availability == 'All'
          ? true
          : availability == 'In stock'
              ? p.inStock
              : !p.inStock;
      return matchesText && matchesCategory && matchesAvailability;
    }).toList();

    emit(ProductLoaded(filtered));
  }
}
