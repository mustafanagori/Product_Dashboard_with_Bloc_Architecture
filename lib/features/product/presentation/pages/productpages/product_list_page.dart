import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_dashboard/features/product/data/datasources/product_local_data_source.dart';
import 'package:product_dashboard/features/product/data/repositories/product.repository_impl.dart';
import 'package:product_dashboard/features/product/presentation/blocs/product_cubit.dart';
import 'package:product_dashboard/features/product/presentation/widgets/product_from_modal.dart';
import 'package:product_dashboard/features/product/presentation/widgets/product_table.dart';
import 'package:product_dashboard/features/product/presentation/widgets/search_filter_bar.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) =>
          ProductCubit(ProductRepositoryImpl(ProductLocalDataSource()))
            ..fetchProducts(),
      child: const ProductListView(),
    );
  }
}

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Text(
            'Product Dashboard',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onBackground,
            ),
          ),
        ),

      
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SearchFilterBar(
            onFilterChanged: (text, category, availability) {
              context.read<ProductCubit>().filterProducts(text, category, availability);
            },
            onSortChanged: (sortBy) {
              context.read<ProductCubit>().sortProducts(sortBy);
            },
          ),
        ),

        const SizedBox(height: 16),

  
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductLoaded) {
                  return ProductTable(products: state.products);
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ),
        ),

  
        Padding(
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: context.read<ProductCubit>(),
                    child: const ProductFormModal(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Product"),
            ),
          ),
        ),
      ],
    );
  }
}
