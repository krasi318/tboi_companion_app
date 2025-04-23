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
        const SnackBar(content: Text('Моля, въведете имейл и парола')),
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
    ).showSnackBar(SnackBar(content: Text('Акаунтът е създаден за $email')));

    Navigator.pop(context); // Go back to login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2C2C2C),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFF1E1E1E), // spooky dark gray
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Регистрация",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple, // Change text color to purple
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Имейл',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Парола',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<Character>(
                value: _selectedCharacter,
                style: const TextStyle(color: Colors.white),

                onChanged: (Character? newValue) {
                  setState(() {
                    _selectedCharacter = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Любим герой',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
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
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  "Регистрирай се",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
