import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_dashboard/features/product/domain/entites/product.entity.dart';
import 'package:product_dashboard/features/product/presentation/blocs/product_cubit.dart';


class ProductFormModal extends StatefulWidget {
  final ProductEntity? editProduct; 
  const ProductFormModal({super.key, this.editProduct});

  @override
  State<ProductFormModal> createState() => _ProductFormModalState();
}

class _ProductFormModalState extends State<ProductFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameCtrl;
  late TextEditingController categoryCtrl;
  late TextEditingController priceCtrl;
  bool inStock = true;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.editProduct?.name ?? '');
    categoryCtrl = TextEditingController(text: widget.editProduct?.category ?? '');
    priceCtrl =
        TextEditingController(text: widget.editProduct?.price.toString() ?? '');
    inStock = widget.editProduct?.inStock ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editProduct != null;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        isEdit ? 'Edit Product' : 'Add Product',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v!.isEmpty ? 'Enter product name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: categoryCtrl,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (v) => v!.isEmpty ? 'Enter category' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Enter price' : null,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                value: inStock,
                title: const Text('In stock'),
                onChanged: (val) => setState(() => inStock = val),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),

     
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {

           
              final cubit = context.read<ProductCubit>();

              if (isEdit) {
                cubit.updateProduct(
                  ProductEntity(
                    id: widget.editProduct!.id,
                    name: nameCtrl.text,
                    category: categoryCtrl.text,
                    price: double.tryParse(priceCtrl.text) ?? 0.0,
                    inStock: inStock,
                  ),
                );
              } else {
                cubit.addProduct(
                  ProductEntity(
                    id: DateTime.now().millisecondsSinceEpoch,
                    name: nameCtrl.text,
                    category: categoryCtrl.text,
                    price: double.tryParse(priceCtrl.text) ?? 0.0,
                    inStock: inStock,
                  ),
                );
              }

              Navigator.pop(context);
            }
          },
          child: Text(isEdit ? 'Update' : 'Save'),
        ),
      ],
    );
  }
}
