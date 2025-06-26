import 'package:flutter/material.dart';
import 'package:flutter_notes_app/auth/auth_gate.dart';
import 'package:flutter_notes_app/auth/auth_service.dart';
import 'package:flutter_notes_app/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Note: Get auth service
  final authService = AuthService();

  //Note: text controllers
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  //Note: Sign Up button pressed
  void signUp() async {
    //Note: Prepare data
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    //Note: Check if passwords match
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Passwords don't match")));
      return;
    }

    if (username == "" || email == "" || password == "") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("All fields are required")));
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Password must be at least 6 characters long")));
      return;
    }

    //Todo: Check if Email exists
    //Note: Try to sign up
    try {
      await authService.signUpWithEmailAndPassword(email, password, username);
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AuthGate(),
          ));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error $email $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 70),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome to the Signup page",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Here you can create a new account",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ],
            ),

            SizedBox(
              height: 50,
            ),

            //Note: Username
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                  labelText: "Username", prefixIcon: Icon(Icons.person)),
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

            //Note: Confirm password
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                  labelText: "Confirm Password", prefixIcon: Icon(Icons.key)),
              obscureText: true,
            ),

            SizedBox(
              height: 30,
            ),

            //Note: Sign Up button
            Container(
              height: 50,
              width: 50,
              child: ElevatedButton(
                onPressed: signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.secondary, // background
                ),
                child: Text(
                  "Sign Up",
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),

            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Center(
                    child: Text(
                  "Have an account? Login",
                ))),
          ],
        ),
      ),
    );
  }
}
