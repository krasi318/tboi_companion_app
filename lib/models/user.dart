// user.dart
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'character.dart'; // Import the enum

class User {
  final int? id;
  final String username;
  final String email;
  final String passwordHash;
  final Character? favoriteCharacter; // Add this line

  // Main constructor: takes raw password and hashes it, takes favorite character
  User({
    this.id,
    required this.username,
    required this.email,
    required String password,
    this.favoriteCharacter,
  }) : passwordHash = _generateHash(password);

  // Named constructor for loading from DB (with already hashed password)
  User.fromDb({
    this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    this.favoriteCharacter, // Include favoriteCharacter here too
  });

  static String _generateHash(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  bool verifyPassword(String password) {
    return _generateHash(password) == passwordHash;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'passwordHash': passwordHash,
      'favoriteCharacter':
          favoriteCharacter
              ?.toString()
              .split('.')
              .last, // Convert enum to string
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User.fromDb(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      passwordHash: map['passwordHash'],
      favoriteCharacter:
          map['favoriteCharacter'] != null
              ? Character.values.firstWhere(
                (e) => e.toString().split('.').last == map['favoriteCharacter'],
              )
              : null, // Convert string back to enum
    );
  }
}
