import 'package:flutter/material.dart';
import 'package:flutter_notes_app/auth/auth_gate.dart';
import 'package:flutter_notes_app/note.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'note.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Note: supabase setup
  await Supabase.initialize(
    url: "https://hqhpvcqyjdmwfjjeiksm.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhxaHB2Y3F5amRtd2ZqamVpa3NtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYxNTM3ODMsImV4cCI6MjA1MTcyOTc4M30.yxUNu7XiSc3I7tzhezYdhCj41OmFJ2y8t-FArDDgm3Y",
  );

  await Hive.initFlutter();
  Hive.registerAdapter(
      NoteAdapter()); // Poznámka: musíš vytvořit adapter (viz níže)
  await Hive.openBox<Note>('notes');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
