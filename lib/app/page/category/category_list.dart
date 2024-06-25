import 'package:flutter/material.dart';
import 'category_add.dart';
import 'category_data.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  // get list

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Danh sách danh mục",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: const Center(child: CategoryBuilder()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (_) => const CategoryAdd(),
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
