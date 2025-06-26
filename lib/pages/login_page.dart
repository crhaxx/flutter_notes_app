import 'package:flutter/material.dart';
import 'package:flutter_notes_app/auth/auth_gate.dart';
import 'package:flutter_notes_app/auth/auth_service.dart';
import 'package:flutter_notes_app/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Note: Get auth service
  final authService = AuthService();

  //Note: text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //Note: Login button pressed
  void login() async {
    //Note: Prepare data
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email == "" || password == "") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please fill in all fields")));
      return;
    }

    //Note: Try to login
    try {
      await authService.signInWithEmailAndPassword(email, password);
      Navigator.pop(context);
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => AuthGate()));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        /* decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.secondary), */
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 70),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome to the login page",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Please login to access the app.",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ],
            ),

            SizedBox(
              height: 50,
            ),

            //Note: Email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                  labelText: "Email", prefixIcon: Icon(Icons.email)),
            ),

            //Note: Password
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                  labelText: "Password", prefixIcon: Icon(Icons.key)),
              obscureText: true,
            ),

            SizedBox(
              height: 12,
            ),

            //Note: Login button
            ElevatedButton(
              onPressed: login,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.secondary, // background
              ),
              child: Text(
                "Login",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inverseSurface),
              ),
            ),

            SizedBox(
              height: 12,
            ),

            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                child: Center(child: Text("Don't have an account? Sign Up"))),
          ],
        ),
      ),
    );
  }
}
