import 'package:flutter/material.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      appBar: AppBar(
        title: Text('Scan Item'),
        backgroundColor: Color(0xFF2C2C2C),
      ),
      body: Center(
        child: Text(
          'Scan feature coming soon...',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
