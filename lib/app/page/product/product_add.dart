import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/model/category.dart';
import 'package:flutter/material.dart';
import 'package:app_api/app/model/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductAdd extends StatefulWidget {
  final bool isUpdate;
  final ProductModel? productModel;

  const ProductAdd(
      {super.key, this.isUpdate = false, this.productModel, required product});

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  String? selectedCate;
  List<CategoryModel> categorys = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imgController = TextEditingController();
  final TextEditingController _catIdController = TextEditingController();
  String titleText = "";

  Future<void> _onSave() async {
    final name = _nameController.text;
    final des = _desController.text;
    final price = double.parse(_priceController.text);
    final img = _imgController.text;
    final catId = _catIdController.text;
    var pref = await SharedPreferences.getInstance();
    await APIRepository().addProduct(
        ProductModel(
            id: 0,
            name: name,
            imageUrl: img,
            categoryId: int.parse(catId),
            categoryName: '',
            price: price,
            description: des),
        pref.getString('token').toString());
    setState(() {});
    Navigator.pop(context);
  }

  Future<void> _onUpdate() async {
    final name = _nameController.text;
    final des = _desController.text;
    final price = double.parse(_priceController.text);
    final img = _imgController.text;
    final catId = _catIdController.text;
    var pref = await SharedPreferences.getInstance();
    //update
    await APIRepository().updateProduct(
        ProductModel(
            id: widget.productModel!.id,
            name: name,
            imageUrl: img,
            categoryId: int.parse(catId),
            categoryName: '',
            price: price,
            description: des),
        pref.getString('accountID').toString(),
        pref.getString('token').toString());
    setState(() {});
    Navigator.pop(context);
  }

  _getCategorys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var temp = await APIRepository().getCategory(
        prefs.getString('accountID').toString(),
        prefs.getString('token').toString());
    setState(() {
      selectedCate = temp.first.id.toString();
      _catIdController.text = selectedCate.toString();
      categorys = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCategorys();

    if (widget.productModel != null && widget.isUpdate) {
      _nameController.text = widget.productModel!.name;
      _desController.text = widget.productModel!.description;
      _priceController.text = widget.productModel!.price.toString();
      _imgController.text = widget.productModel!.imageUrl;
      _catIdController.text = widget.productModel!.categoryId.toString();
    }
    if (widget.isUpdate) {
      titleText = "Chỉnh sửa sản phẩm";
    } else
      titleText = "Thêm mới sản phẩm";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titleText,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Tên sản phẩm',
                prefixIcon: Icon(Icons.edit, color: Colors.teal),
              ),
            ),
            const SizedBox(height: 5.0),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Giá',
                prefixIcon: Icon(Icons.price_change, color: Colors.teal),
              ),
            ),
            const SizedBox(height: 5.0),
            TextField(
              controller: _imgController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Hình ảnh',
                prefixIcon: Icon(Icons.image, color: Colors.teal),
              ),
            ),
            const SizedBox(height: 5.0),
            TextField(
              controller: _desController,
              maxLines: 2,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Mô tả',
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Icon(Icons.description, color: Colors.teal),
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            _buildCategoryDropdown(),
            const SizedBox(height: 5.0),
            SizedBox(
              height: 45.0,
              child: ElevatedButton(
                onPressed: () async {
                  widget.isUpdate ? _onUpdate() : _onSave();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                child: const Text(
                  'Lưu',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          value: selectedCate,
          items: categorys
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item.id.toString(),
                  child: Text(
                    item.name,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              )
              .toList(),
          onChanged: (item) {
            setState(() {
              selectedCate = item;
              _catIdController.text = item.toString();
            });
          },
        ),
      ],
    );
  }
}
