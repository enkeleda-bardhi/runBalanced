import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:run_balanced/screens/signup_screen.dart';

const double kDefaultPadding = 16.0;

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUserWithEmailAndPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Error logging in")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login Run Balanced',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Welcome back!',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: kDefaultPadding),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: kDefaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account yet? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: kDefaultPadding),
              ElevatedButton(
                onPressed: () async {
                  await loginUserWithEmailAndPassword(context);
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
