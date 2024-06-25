import 'dart:io';
import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/data/sqlite.dart';
import 'package:app_api/app/model/cart.dart';
import 'package:app_api/app/model/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBuilder extends StatefulWidget {
  const HomeBuilder({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeBuilder> createState() => _HomeBuilderState();
}

class _HomeBuilderState extends State<HomeBuilder> {
  final DatabaseHelper _databaseService = DatabaseHelper();

  Future<List<ProductModel>> _getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getListAdmin(
      prefs.getString('token').toString(),
    );
  }

  Future<void> _onSave(ProductModel pro) async {
    _databaseService.insertProduct(Cart(
      productID: pro.id,
      name: pro.name,
      des: pro.description,
      price: pro.price,
      img: pro.imageUrl,
      count: 1,
    ));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ProductModel>>(
        future: _getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75, // Số cột trong lưới
                  crossAxisSpacing: 4, // Khoảng cách giữa các cột
                  mainAxisSpacing: 8.0, // Khoảng cách giữa các hàng
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final itemProduct = snapshot.data![index];
                  return itemGridView(itemProduct);
                },
              ),
            );
          }
          return const Center(
            child: Text('No data available'),
          );
        },
      ),
    );
  }

  Widget itemGridView(ProductModel productModel) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Image.network(
                  productModel.imageUrl ??
                      '', // Sử dụng URL hình ảnh từ productModel
                  height: 100,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                productModel.name != null
                    ? (productModel.name!.length > 20
                        ? '${productModel.name!.substring(0, 15)}...' // Hiển thị chỉ 20 ký tự đầu tiên của tên sản phẩm và dấu ba chấm
                        : productModel
                            .name) // Hiển thị toàn bộ tên sản phẩm nếu độ dài không vượt quá 20 ký tự
                    : '',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                NumberFormat('###,###.###₫').format(productModel.price),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  _onSave(
                      productModel); // Lưu sản phẩm vào giỏ hàng khi nhấn nút
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${productModel.name} added to cart.'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Màu nền của button
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(
                        15.0,
                      ), // Chỉ áp dụng border cho 2 góc dưới của button
                    ),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24,
                      ), // Icon "Add"
                      SizedBox(width: 8),
                      Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ), // Text "Add"
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 244, 222, 54),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: const Text(
                '15%',
                style: TextStyle(
                  color: Color.fromARGB(255, 26, 25, 25),
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const Positioned(
            top: 0,
            right: 0,
            child: FavoriteButton(), // Sử dụng FavoriteButton ở đây
          ),
        ],
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          _isFavorite = !_isFavorite;
        });
      },
      icon: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: _isFavorite ? Colors.red : Colors.grey,
      ),
    );
  }
}
