class Note {
  int? id;
  String title;
  String description;

  Note({
    this.id,
    required this.title,
    required this.description,
  });

  // Convert a Note into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  // Implement toString to make it easier to see information about each note when using the print statement.
  @override
  String toString() {
    return 'Note{id: $id, title: $title, description: $description}';
  }
}
