import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'note.dart';
import 'category.dart';

class NotesPage extends StatefulWidget {
  final Category category;

  NotesPage({required this.category});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
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
      notes = notesList.where((note) => note.categoryId == widget.category.id).toList();
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
          categoryId: widget.category.id!,
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
        title: Text(widget.category.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16.0),
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
                          icon: Icon(Icons.edit),
                          onPressed: () => _editNote(note),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
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
