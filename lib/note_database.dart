import 'package:flutter_notes_app/note.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NoteDatabase {
  //Info: Database -> notes
  final database = Supabase.instance.client.from('notes');

  //Info: Create
  Future createNote(Note newNote) async {
    await database.insert(newNote.toMap());
  }

  //Info: Read
  final steam = Supabase.instance.client.from('notes').stream(primaryKey: [
    'id'
  ]).map((data) => data.map((noteMap) => Note.fromMap(noteMap)).toList());

  //Info: Upadate
  Future updateNote(Note oldNote, String newContent) async {
    await database.update({
      'content': newContent,
    }).eq('id', oldNote.id!);
  }

  //Info: Delete
  Future deleteNote(Note note) async {
    await database.delete().eq('id', note.id!);
  }
}
