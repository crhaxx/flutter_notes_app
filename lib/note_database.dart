import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'note.dart';
import 'package:collection/collection.dart';

class NoteDatabase {
  final supabase = Supabase.instance.client;
  final Box<Note> localBox = Hive.box<Note>('notes');

  // Vytvoření nebo aktualizace poznámky lokálně
  Future<void> saveLocalNote(Note note) async {
    if (note.id != null) {
      await localBox.put(note.id!, note);
    } else {
      final key = await localBox.add(note);
      note.id = key;
      await localBox.put(key, note);
    }
  }

  // Získání všech lokálních poznámek
  List<Note> getLocalNotes() {
    return localBox.values.toList();
  }

  // CRUD: vytvoření nové poznámky
  Future<void> createNote(Note note) async {
    await saveLocalNote(note);
    await pushNoteToRemote(note);
  }

  // CRUD: aktualizace poznámky s novým obsahem
  Future<void> updateNote(Note note, String newContent) async {
    note.content = newContent;
    note.updatedAt = DateTime.now();
    await saveLocalNote(note);
    await pushNoteToRemote(note);
  }

  // CRUD: smazání poznámky lokálně i na serveru
  Future<void> deleteNote(Note note) async {
    if (note.id != null) {
      await deleteRemoteNote(note.id!);
    }
    final key = note.id ?? note.key;
    await localBox.delete(key);
  }

  // Načtení poznámek ze Supabase
  Future<List<Note>> fetchRemoteNotes() async {
    final data = await supabase.from('notes').select();
    if (data == null) return [];
    return (data as List)
        .map((e) => Note.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  // Push poznámky na Supabase (insert nebo update)
  Future<void> pushNoteToRemote(Note note) async {
    final now = DateTime.now();
    note.updatedAt = now;
    if (note.createdAt == null) note.createdAt = now;

    print("Pushing note to remote: ${note.toMap()}");

    final data = await supabase
        .from('notes')
        .upsert(note.toMap())
        .select()
        .maybeSingle();

    if (data == null) {
      print("Upsert returned null data");
      throw Exception("Failed to upsert note");
    }

    print("Upsert success: $data");

    note.id = data['id'] as int?;
    await saveLocalNote(note);
  }

  // Smazání poznámky na Supabase
  Future<void> deleteRemoteNote(int id) async {
    final data = await supabase
        .from('notes')
        .delete()
        .eq('id', id)
        .select()
        .maybeSingle();

    if (data == null) throw Exception("Failed to delete note");
  }

  // Synchronizace: stáhni remote a aktualizuj lokální a naopak
  Future<void> sync() async {
    final remoteNotes = await fetchRemoteNotes();
    final localNotes = getLocalNotes();

    // 1) Aktualizuj lokální poznámky podle novějších remote poznámek
    for (var remoteNote in remoteNotes) {
      final localNote =
          localBox.values.firstWhereOrNull((n) => n.id == remoteNote.id);

      if (localNote == null) {
        await saveLocalNote(remoteNote);
      } else if (remoteNote.updatedAt != null &&
          (localNote.updatedAt == null ||
              remoteNote.updatedAt!.isAfter(localNote.updatedAt!))) {
        await saveLocalNote(remoteNote);
      }
    }

    // 2) Pushni lokální poznámky, které jsou novější než remote nebo tam nejsou
    for (var localNote in localNotes) {
      final remoteNote =
          remoteNotes.firstWhereOrNull((n) => n.id == localNote.id);

      if (remoteNote == null) {
        await pushNoteToRemote(localNote);
      } else if (localNote.updatedAt != null &&
          (remoteNote.updatedAt == null ||
              localNote.updatedAt!.isAfter(remoteNote.updatedAt!))) {
        await pushNoteToRemote(localNote);
      }
    }
  }
}
