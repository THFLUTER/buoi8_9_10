import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/model/category.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'category_add.dart';

class CategoryBuilder extends StatefulWidget {
  const CategoryBuilder({Key? key}) : super(key: key);

  @override
  State<CategoryBuilder> createState() => _CategoryBuilderState();
}

class _CategoryBuilderState extends State<CategoryBuilder> {
  Future<List<CategoryModel>> _getCategorys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getCategory(
        prefs.getString('accountID').toString(),
        prefs.getString('token').toString());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CategoryModel>>(
      future: _getCategorys(),
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
              final itemCat = snapshot.data![index];
              return _buildCategory(itemCat, context);
            },
          ),
        );
      },
    );
  }

  Widget _buildCategory(CategoryModel category, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              height: 60.0,
              width: 60.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              alignment: Alignment.center,
              child: Text(
                category.id.toString(),
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(category.desc),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                setState(() async {
                  await APIRepository().removeCategory(
                      category.id,
                      pref.getString('accountID').toString(),
                      pref.getString('token').toString());
                  // Reload the list after deletion
                  setState(() {});
                });
              },
              icon: const Icon(
                Icons.delete_outline_outlined,
                color: Colors.red,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (_) => CategoryAdd(
                          isUpdate: true,
                          categoryModel: category,
                        ),
                        fullscreenDialog: true,
                      ),
                    )
                    .then((_) => setState(() {}));
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
