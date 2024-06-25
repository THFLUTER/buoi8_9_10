import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/model/category.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryAdd extends StatefulWidget {
  final bool isUpdate;
  final CategoryModel? categoryModel;
  const CategoryAdd({Key? key, this.isUpdate = false, this.categoryModel})
      : super(key: key);

  @override
  State<CategoryAdd> createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String titleText = "";

  Future<void> _onSave() async {
    final name = _nameController.text;
    final description = _descController.text;
    final image = _imageController.text;
    var pref = await SharedPreferences.getInstance();
    await APIRepository().addCategory(
        CategoryModel(id: 0, name: name, imageUrl: image, desc: description),
        pref.getString('accountID').toString(),
        pref.getString('token').toString());
    setState(() {});
    Navigator.pop(context);
  }

  Future<void> _onUpdate(int id) async {
    final name = _nameController.text;
    final description = _descController.text;
    final image = _imageController.text;
    var pref = await SharedPreferences.getInstance();

    //update
    await APIRepository().updateCategory(
        id,
        CategoryModel(
            id: widget.categoryModel!.id,
            name: name,
            imageUrl: image,
            desc: description),
        pref.getString('accountID').toString(),
        pref.getString('token').toString());
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if (widget.categoryModel != null && widget.isUpdate) {
      _nameController.text = widget.categoryModel!.name;
      _descController.text = widget.categoryModel!.desc;
      _imageController.text = widget.categoryModel!.imageUrl;
    }
    if (widget.isUpdate) {
      titleText = "Chỉnh sửa danh mục";
    } else {
      titleText = "Tạo mới danh mục";
    }
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
                hintText: 'Tên danh mục',
                prefixIcon: Icon(Icons.category, color: Colors.teal),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Hình ảnh',
                prefixIcon: Icon(Icons.image, color: Colors.teal),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Mô tả',
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 100.0),
                  child: Icon(Icons.description, color: Colors.teal),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 45.0,
              child: ElevatedButton(
                onPressed: () {
                  widget.isUpdate
                      ? _onUpdate(widget.categoryModel!.id)
                      : _onSave();
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
}
