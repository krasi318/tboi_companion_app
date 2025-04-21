import 'package:flutter/material.dart';
import 'package:tboi_companion_app/models/character.dart';
import 'package:tboi_companion_app/models/user.dart';
import 'package:tboi_companion_app/db/database_helper.dart'; // Import DatabaseHelper

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Character? _selectedCharacter = Character.isaac; // Default selection

  // Register user and insert to database
  void _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Validate inputs
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    // Create a new user with favorite character
    final user = User(
      username: email,
      email: email,
      password: password, // Password will be hashed in the User model
      favoriteCharacter: _selectedCharacter,
    );

    // Save the user to the database using DatabaseHelper
    final db = DatabaseHelper.instance;
    await db.insertUser(user);

    // Show confirmation message and navigate back to login
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Account created for $email')));

    Navigator.pop(context); // Go back to login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            // Dropdown for selecting favorite character
            DropdownButton<Character>(
              value: _selectedCharacter,
              onChanged: (Character? newValue) {
                setState(() {
                  _selectedCharacter = newValue;
                });
              },
              items:
                  Character.values.map<DropdownMenuItem<Character>>((
                    Character value,
                  ) {
                    return DropdownMenuItem<Character>(
                      value: value,
                      child: Text(
                        value.toString().split('.').last,
                      ), // Show character name
                    );
                  }).toList(),
            ),

            const SizedBox(height: 20),
            ElevatedButton(onPressed: _register, child: const Text("Register")),
          ],
        ),
      ),
    );
  }
}
