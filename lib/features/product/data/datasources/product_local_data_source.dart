import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:product_dashboard/features/product/model/product_model.dart';

class ProductLocalDataSource {
  Future<List<ProductModel>> fetchProducts() async {
    final data = await rootBundle.loadString('assets/products.json');
    final jsonList = jsonDecode(data) as List;
    return jsonList.map((e) => ProductModel.fromJson(e)).toList();
  }
}
