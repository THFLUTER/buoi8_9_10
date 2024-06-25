import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/data/sqlite.dart';
import 'package:app_api/app/model/cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Cart>> _getProducts() async {
    return await _databaseHelper.products();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Cart>>(
              future: _getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final itemProduct = snapshot.data![index];
                    return _buildProduct(itemProduct, context);
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Tổng tiền:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                FutureBuilder<List<Cart>>(
                  future: _getProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        'Đang thực hiện.',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    final total = snapshot.data!.isEmpty
                        ? 0
                        : snapshot.data!
                            .map<int>((product) =>
                                (product.price * product.count).round())
                            .reduce((a, b) => a + b);
                    return Text(
                      '${NumberFormat('#,##0₫').format(total)}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  List<Cart> temp = await _databaseHelper.products();
                  await APIRepository()
                      .addBill(temp, pref.getString('token').toString());
                  _databaseHelper.clear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Đặt hàng',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProduct(Cart pro, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.yellow[800],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image.network(
                pro.img, // Đường dẫn hình ảnh của sản phẩm
                width: 80,
                height: 80,
                fit: BoxFit
                    .cover, // Đảm bảo hình ảnh phù hợp với kích thước của container
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pro.name.length > 15
                        ? '${pro.name.substring(0, 15)}...'
                        : pro.name,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    NumberFormat('#,##0₫').format(pro.price),
                    style: const TextStyle(
                      fontSize: 13.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _databaseHelper.minus(pro);
                        });
                      },
                      icon: const Icon(Icons.remove),
                      color: Colors.teal,
                    ),
                    Text(
                      pro.count.toString(),
                      style: const TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _databaseHelper.add(pro);
                        });
                      },
                      icon: const Icon(Icons.add),
                      color: Colors.teal,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                const SizedBox(
                  height: 15.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    _databaseHelper.deleteProduct(pro.productID);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
