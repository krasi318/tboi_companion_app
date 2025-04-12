import 'package:flutter/material.dart';
import 'package:tboi_companion_app/db/seed_data.dart';
import 'item_library_screen.dart';
import 'search_screen.dart';
import 'scan_screen.dart';
import 'db/database_helper.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.database; // This will create the database if it doesn't exist

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

class IsaacCompanionApp extends StatelessWidget {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E), // spooky dark gray
      appBar: AppBar(
        title: Text('Binding of Isaac Companion'),
        backgroundColor: Color(0xFF2C2C2C),
      ),
      body: Center(
        child: Text(
          'Welcome to the Isaac Companion!',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
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
