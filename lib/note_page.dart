import 'package:flutter/material.dart';
import 'package:flutter_notes_app/auth/auth_service.dart';
import 'package:flutter_notes_app/note.dart';
import 'package:flutter_notes_app/note_database.dart';
import 'package:flutter_notes_app/optionsmenu/data/menu_items.dart';
import 'package:flutter_notes_app/optionsmenu/model/menu_item.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  @override
  void initState() {
    super.initState();
    _initSync();
  }

  Future<void> _initSync() async {
    try {
      await notesDatabase.sync();
    } catch (e) {
      print("Sync error: $e");
    }
  }

  //Note: notes db
  final notesDatabase = NoteDatabase();

  //Note: text controller
  final noteController = TextEditingController();

  //Note: Get auth service
  final authService = AuthService();

  //Info: user wants to add a new note
  void addNewNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("New Note"),
        content: TextField(
          controller: noteController,
        ),
        actions: [
          //Note: cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              noteController.clear();
            },
            child: Text("Cancel"),
          ),

          //Note: save button
          TextButton(
            onPressed: () {
              //Note: create a new note
              final newNote = Note(
                  content: noteController.text,
                  author: authService.getCurrentUserEmail());

              //Note: save the note to the database
              notesDatabase.createNote(newNote);

              Navigator.pop(context);
              noteController.clear();
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  //Info: user wants to update an existing note
  void updateNote(Note note) {
    //Note: pre-fill text controller with existing note
    noteController.text = note.content;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Update Note"),
        content: TextField(
          controller: noteController,
        ),
        actions: [
          //Note: cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              noteController.clear();
            },
            child: Text("Cancel"),
          ),

          //Note: save button
          TextButton(
            onPressed: () {
              //Note: save the note to the database
              notesDatabase.updateNote(note, noteController.text);

              Navigator.pop(context);
              noteController.clear();
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  //Info: user wants to delete note
  void deleteNote(Note note) {
    //Note: pre-fill text controller with existing note
    noteController.text = note.content;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Note?"),
        actions: [
          //Note: cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              noteController.clear();
            },
            child: Text("Cancel"),
          ),

          //Note: save button
          TextButton(
            onPressed: () {
              //Note: save the note to the database
              notesDatabase.deleteNote(note);

              Navigator.pop(context);
              noteController.clear();
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  void logout() {
    authService.signOut();
  }

  PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem<MenuItem>(
        value: item,
        child: Row(
          children: [
            Icon(
              item.icon,
              color: Colors.black,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(item.text)
          ],
        ),
      );

  void onSelected(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.itemsSettings:
        //TODO: ADD SETTINGS PAGE
        break;

      case MenuItems.itemsSignOut:
        authService.signOut();
        break;
    }
  }

  //Note: BUILD UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      //Note: AppBar
      appBar: AppBar(
        title: const Text(
          'My Notes',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton<MenuItem>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                    ...MenuItems.itemsFirst.map(buildItem),
                    PopupMenuDivider(),
                    ...MenuItems.itemsSecond.map(buildItem)
                  ])
        ],
        backgroundColor: Colors.black,
      ),

      //Note: Button
      floatingActionButton: FloatingActionButton(
        onPressed: addNewNote,
        shape: CircleBorder(),
        backgroundColor: Colors.amber,
        child: Icon(Icons.add, color: Colors.white),
      ),

      //Info: Body -> StreamBuilder
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Note>('notes').listenable(),
        builder: (context, Box<Note> box, _) {
          final currentUserEmail = authService.getCurrentUserEmail();
          final userNotes = box.values
              .where((note) => note.author == currentUserEmail)
              .toList();

          if (userNotes.isEmpty) {
            return Center(child: Text('No notes found'));
          }

          return GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: userNotes.length,
            itemBuilder: (context, index) {
              final note = userNotes[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white,
                    width: 0.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ListTile(
                      title: Text(
                        note.content,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () => updateNote(note),
                          icon: Icon(Icons.edit, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () => deleteNote(note),
                          icon: Icon(Icons.delete, color: Colors.white),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
