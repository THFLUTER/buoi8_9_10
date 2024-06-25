// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/model/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'product_add.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductBuilder extends StatefulWidget {
  const ProductBuilder({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductBuilder> createState() => _ProductBuilderState();
}

class _ProductBuilderState extends State<ProductBuilder> {
  Future<List<ProductModel>> _getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getProduct(
        prefs.getString('accountID').toString(),
        prefs.getString('token').toString());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: _getProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final itemProduct = snapshot.data![index];
              return _buildProduct(itemProduct, context);
            },
          ),
        );
      },
    );
  }

  Widget _buildProduct(ProductModel pro, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage(pro.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.center,
              child: Image(
                  width: 128,
                  height: 128,
                  fit: BoxFit.cover,
                  image: FileImage(File(pro.imageUrl))),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pro.name,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    NumberFormat('#,##0').format(pro.price),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.red,
                    ),
                  ),
                  // const SizedBox(height: 4.0),
                  // Text('Category: ${pro.catId}'),
                  const SizedBox(height: 4.0),
                  Text('Description: ' + pro.description),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                setState(() async {
                  await APIRepository().removeProduct(
                      pro.id,
                      pref.getString('accountID').toString(),
                      pref.getString('token').toString());
                });
              },
              icon: const Icon(
                Icons.delete_outline_outlined,
                color: Colors.red,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (_) => ProductAdd(
                            isUpdate: true,
                            productModel: pro,
                            product: null,
                          ),
                          fullscreenDialog: true,
                        ),
                      )
                      .then((_) => setState(() {}));
                });
              },
              icon: const Icon(
                Icons.edit_outlined,
                color: Color.fromARGB(255, 225, 153, 51),
              ),
            )
          ],
        ),
      ),
    );
  }
}
