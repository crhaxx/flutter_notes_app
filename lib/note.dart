import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String content;

  @HiveField(2)
  String author;

  @HiveField(3)
  DateTime? createdAt;

  @HiveField(4)
  DateTime? updatedAt;

  Note({
    this.id,
    required this.content,
    required this.author,
    this.createdAt,
    this.updatedAt,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      content: map['content'] as String,
      author: map['author'] as String,
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt:
          map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'author': author,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
