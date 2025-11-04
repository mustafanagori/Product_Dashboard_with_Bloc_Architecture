import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_dashboard/features/product/domain/entites/product.entity.dart';
import 'package:product_dashboard/features/product/presentation/blocs/product_cubit.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
     
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoaded) {
            final ProductEntity? product = state.products
                .where((p) => p.id == productId)
                .cast<ProductEntity?>()
                .firstOrNull;

            if (product == null) {
              return const Center(
                child: Text('Product not found'),
              );
            }

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Card(
                    elevation: 3,
                    color: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         
                          Row(
                            children: [
                              Icon(Icons.inventory_2_outlined,
                                  size: 36, color: colorScheme.primary),
                              const SizedBox(width: 12),
                              Text(
                                product.name,
                                style: textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _infoTile(
                                    icon: Icons.category_outlined,
                                    label: 'Category',
                                    value: product.category,
                                    color: colorScheme.primary,
                                  ),
                                  _infoTile(
                                    icon: Icons.attach_money_outlined,
                                    label: 'Price',
                                    value:
                                        '\$${product.price.toStringAsFixed(2)}',
                                    color: colorScheme.secondary,
                                  ),
                                  _infoTile(
                                    icon: Icons.check_circle_outline,
                                    label: 'Stock',
                                    value: product.inStock
                                        ? 'In stock'
                                        : 'Out of stock',
                                    color: product.inStock
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ],
                              );
                            },
                          ),

                          const Spacer(),

                         
                          Align(
                            alignment: Alignment.center,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back),
                              label: const Text('Back to List'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('No product data available'));
          }
        },
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

extension _IterableExt<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
