import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_dashboard/features/product/domain/entites/product.entity.dart';
import 'package:product_dashboard/features/product/presentation/blocs/product_cubit.dart';
import 'package:product_dashboard/features/product/presentation/pages/productpages/product_detail_page.dart';
import 'package:product_dashboard/features/product/presentation/widgets/product_from_modal.dart';

class ProductTable extends StatefulWidget {
  final List<ProductEntity> products;
  const ProductTable({super.key, required this.products});

  @override
  State<ProductTable> createState() => _ProductTableState();
}

class _ProductTableState extends State<ProductTable> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  Widget build(BuildContext context) {
    final dataSource = _ProductDataSource(widget.products, context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return PaginatedDataTable2(
          headingRowColor: WidgetStateColor.resolveWith(
            (states) => Theme.of(context).colorScheme.surfaceVariant,
          ),
          columnSpacing: 16,
          horizontalMargin: 16,
          showCheckboxColumn: false,
          rowsPerPage: _rowsPerPage,
          availableRowsPerPage: const [5, 10, 20],
          onRowsPerPageChanged:
              (value) => setState(() => _rowsPerPage = value ?? 5),
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          columns: [
            DataColumn2(
              label: const Text('ID'),
              onSort: (i, asc) {
                setState(() {
                  _sortColumnIndex = i;
                  _sortAscending = asc;
                });
                context.read<ProductCubit>().sortProducts('id');
              },
              size: ColumnSize.S,
            ),
            DataColumn2(
              label: const Text('Name'),
              onSort: (i, asc) {
                setState(() {
                  _sortColumnIndex = i;
                  _sortAscending = asc;
                });
                context.read<ProductCubit>().sortProducts('name');
              },
            ),
            DataColumn2(
              label: const Text('Category'),
              onSort: (i, asc) {
                setState(() {
                  _sortColumnIndex = i;
                  _sortAscending = asc;
                });
                context.read<ProductCubit>().sortProducts('category');
              },
            ),
            DataColumn2(
              label: const Text('Price'),
              numeric: true,
              onSort: (i, asc) {
                setState(() {
                  _sortColumnIndex = i;
                  _sortAscending = asc;
                });
                context.read<ProductCubit>().sortProducts('price');
              },
            ),
            const DataColumn2(label: Text('Stock')),
            const DataColumn2(label: Text('Actions')),
          ],
          source: dataSource,
        );
      },
    );
  }
}

class _ProductDataSource extends DataTableSource {
  final List<ProductEntity> products;
  final BuildContext context;

  _ProductDataSource(this.products, this.context);

  @override
  DataRow? getRow(int index) {
    if (index >= products.length) return null;
    final p = products[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(p.id.toString())),
        DataCell(Text(p.name)),
        DataCell(Text(p.category)),
        DataCell(Text('\$${p.price.toStringAsFixed(2)}')),
        DataCell(
          Text(
            p.inStock ? 'In stock' : 'Out of stock',
            style: TextStyle(
              color: p.inStock ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                tooltip: 'Edit',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (_) => BlocProvider.value(
                          value: context.read<ProductCubit>(),
                          child: ProductFormModal(editProduct: p),
                        ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20 , color: Colors.red,),
                tooltip: 'Delete',
                onPressed: () {
                  context.read<ProductCubit>().deleteProduct(p.id);
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(productId: p.id),
                    ),
                  );
                },
                child: const Text('View'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => products.length;
  @override
  int get selectedRowCount => 0;
}
