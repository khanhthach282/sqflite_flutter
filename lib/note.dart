class Note {
  int? id;
  String title;
  String description;
  int categoryId; // Foreign key

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.categoryId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'categoryId': categoryId,
    };
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, description: $description, categoryId: $categoryId}';
  }
}
