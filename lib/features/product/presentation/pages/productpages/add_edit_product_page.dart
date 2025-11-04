import 'package:flutter/material.dart';


class AddEditProductPage extends StatelessWidget {


  const AddEditProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add and edit product page')),
      body: Center(
        child: Text('Detailed info for Product ID'),
      ),
    );
  }
}
