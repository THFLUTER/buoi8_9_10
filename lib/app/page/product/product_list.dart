import 'package:app_api/app/page/product/product_add.dart';
import 'package:app_api/app/page/product/product_data.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Danh sách sản phẩm",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: const Center(child: ProductBuilder()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (_) => const ProductAdd(
                    product: null,
                  ),
                  fullscreenDialog: true,
                ),
              )
              .then((_) => setState(() {}));
        },
        tooltip: 'Add New',
        backgroundColor: Colors.teal,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
