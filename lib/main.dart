import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tboi_companion_app/db/seed_data.dart';
import 'item_library_screen.dart';
import 'search_screen.dart';
import 'scan_screen.dart';
import 'db/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final db = DatabaseHelper.instance;

  await db.clearItems();
  await SeedData.insertInitialData();

  runApp(IsaacCompanionApp(cameras: cameras));
}

class IsaacCompanionApp extends StatelessWidget {
  const IsaacCompanionApp({
    super.key,
    required List<CameraDescription> cameras,
  });

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
