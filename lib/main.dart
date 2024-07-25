import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'category.dart';
import 'notes_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sqflite Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final TextEditingController categoryController = TextEditingController();
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categoriesList = await dbHelper.categories();
    setState(() {
      categories = categoriesList;
    });
  }

  Future<void> _addCategory() async {
    final name = categoryController.text;
    if (name.isNotEmpty) {
      final category = Category(name: name);
      await dbHelper.insertCategory(category);
      categoryController.clear();
      _loadCategories();
    }
  }

  Future<void> _deleteCategory(int id) async {
    await dbHelper.deleteCategory(id);
    _loadCategories();
  }

  void _navigateToNotesPage(Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotesPage(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Sqflite Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            ElevatedButton(
              onPressed: _addCategory,
              child: Text('Add Category'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return ListTile(
                    title: Text(category.name),
                    onTap: () => _navigateToNotesPage(category),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteCategory(category.id!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
