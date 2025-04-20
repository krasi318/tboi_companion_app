import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tboi_companion_app/db/seed_data.dart';
import 'screens/item_library_screen.dart';
import 'screens/search_screen.dart';
import 'screens/scan_screen.dart';
import 'db/database_helper.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  String dbPath = await getDatabasePath();
  print("Database Path: $dbPath");

  // Initialize database
  final dbHelper = DatabaseHelper.instance;
  await DatabaseHelper
      .instance
      .database; // This will drop and recreate the database

  // Check if database is empty and seed if needed
  final items = await dbHelper.getAllItems();
  if (items.isEmpty) {
    await SeedData.insertInitialData();
    print('Database seeded with initial items!');
  }

  // Print the hash of the first image in the database
  if (items.isNotEmpty) {
    print('Pixel Hash of first item: ${items[0].pixelHash}');
  } else {
    print('No items found in the database');
  }

  runApp(IsaacCompanionApp());
}

Future<String> getDatabasePath() async {
  final directory = await getApplicationDocumentsDirectory();
  final dbPath = join(directory.path, 'all_items.db');
  print("Database Path: $dbPath"); // This will print the path to the console
  return dbPath;
}

class IsaacCompanionApp extends StatelessWidget {
  const IsaacCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Isaac Companion',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E), // spooky dark gray
      appBar: AppBar(
        title: Text(
          'Binding of Isaac Companion',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF2C2C2C),
      ),
      body: Stack(
        children: [
          // You can still have a centered widget here if you want
          Center(
            child: Text(
              "Welcome to the Isaac Companion!",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),

          // Bottom-right positioned search helper
          Positioned(
            bottom: 80,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Can't find your item?",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchScreen()),
                    );
                  },
                  child: Text(
                    "Try searching manually →",
                    style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF2C2C2C),
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.library_books, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ItemLibraryScreen()),
                );
              },
              tooltip: "Item Library",
            ),
            SizedBox(width: 48), // spacer for FAB
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              },
              tooltip: "Search",
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 72,
        width: 72,
        child: FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: Colors.deepPurple,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScanScreen()),
            );
          },
          tooltip: "Scan Item",
          child: Icon(Icons.camera_alt, size: 32),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
