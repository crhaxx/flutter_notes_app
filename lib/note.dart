class Note {
  int? id;
  String content;
  String author;

  Note({
    this.id,
    required this.content,
    required this.author,
  });

  //Info: map -> note
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
        id: map['id'] as int,
        content: map['content'] as String,
        author: map['author'] as String);
  }

  //Info: note -> map
  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'author': author,
    };
  }
}
