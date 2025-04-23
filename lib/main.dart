import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tboi_companion_app/db/seed_data.dart';
import 'package:tboi_companion_app/models/user.dart';
import 'screens/item_library_screen.dart';
import 'screens/search_screen.dart';
import 'screens/scan_screen.dart';
import 'db/database_helper.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String dbPath = await getDatabasePath();
  print("Път до базата данни: $dbPath");

  final dbHelper = DatabaseHelper.instance;
  await DatabaseHelper.instance.database;

  final items = await dbHelper.getAllItems();
  if (items.isEmpty) {
    await SeedData.insertInitialData();
    print('Базата данни е попълнена с начални данни!');
  }

  if (items.isNotEmpty) {
    print('Хеш на първия елемент: ${items[0].pixelHash}');
  } else {
    print('Няма намерени елементи в базата данни');
  }

  runApp(IsaacCompanionApp());
}

Future<String> getDatabasePath() async {
  final directory = await getApplicationDocumentsDirectory();
  final dbPath = join(directory.path, 'all_items.db');
  print("Път до базата данни: $dbPath");
  return dbPath;
}

class IsaacCompanionApp extends StatelessWidget {
  const IsaacCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Isaac Companion',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)?.settings.arguments as User?;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text(
          'Придружител за Binding of Isaac',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2C2C2C),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Text(
              user != null
                  ? "Здравей, ${user.username}!"
                  : "Добре дошли в Придружителя за Isaac!",
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          Positioned(
            top: 150,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Наскоро сканирани:",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Positioned(
            bottom: 80,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  "Не можете да намерите вашия елемент?",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchScreen()),
                    );
                  },
                  child: const Text(
                    "Опитайте да търсите ръчно →",
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
        color: const Color(0xFF2C2C2C),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.library_books, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ItemLibraryScreen()),
                );
              },
              tooltip: "Библиотека с елементи",
            ),
            const SizedBox(width: 48),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              },
              tooltip: "Търсене",
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 72,
        width: 72,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Colors.deepPurple,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScanScreen()),
            );
          },
          tooltip: "Сканиране на елемент",
          child: const Icon(Icons.camera_alt, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
