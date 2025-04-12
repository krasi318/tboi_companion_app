import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      appBar: AppBar(
        title: Text('Search Items'),
        backgroundColor: Color(0xFF2C2C2C),
      ),
      body: Center(
        child: Text(
          'Search items by name or effect.',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
