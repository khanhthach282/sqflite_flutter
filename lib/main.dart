import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'note.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sqflite Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<Note> notes = [];
  Note? _selectedNote;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notesList = await dbHelper.notes();
    setState(() {
      notes = notesList;
    });
  }

  Future<void> _addOrUpdateNote() async {
    final title = titleController.text;
    final description = descriptionController.text;
    if (title.isNotEmpty && description.isNotEmpty) {
      if (_selectedNote == null) {
        final note = Note(
          title: title,
          description: description,
        );
        await dbHelper.insertNote(note);
      } else {
        _selectedNote!.title = title;
        _selectedNote!.description = description;
        await dbHelper.updateNote(_selectedNote!);
        _selectedNote = null;
      }
      titleController.clear();
      descriptionController.clear();
      _loadNotes();
    }
  }

  Future<void> _deleteNote(int id) async {
    await dbHelper.deleteNote(id);
    _loadNotes();
  }

  void _editNote(Note note) {
    setState(() {
      _selectedNote = note;
      titleController.text = note.title;
      descriptionController.text = note.description;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Sqflite Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addOrUpdateNote,
              child: Text(_selectedNote == null ? 'Add Note' : 'Update Note'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return ListTile(
                    title: Text(note.title),
                    subtitle: Text(note.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editNote(note),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteNote(note.id!),
                        ),
                      ],
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

