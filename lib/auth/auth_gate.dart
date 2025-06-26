//INFO: Continuously check for auth state changes. Unauthenticated -> LoginPage, Authenticated -> HomePage

import 'package:flutter/material.dart';
import 'package:flutter_notes_app/note_page.dart';
import 'package:flutter_notes_app/pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        //Note: Listen to auth state changes
        stream: Supabase.instance.client.auth.onAuthStateChange,

        //Info: Build page
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          //Note: Check if there is a valid session currently
          final session = snapshot.hasData ? snapshot.data!.session : null;

          if (session != null) {
            return NotePage();
          } else {
            return LoginPage();
          }
        });
  }
}
