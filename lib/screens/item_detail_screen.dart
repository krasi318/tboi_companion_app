import 'package:flutter/material.dart';
import '../models/item.dart';

class ItemDetailScreen extends StatelessWidget {
  final Item item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: Text(item.name),
        backgroundColor: const Color(0xFF2C2C2C),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Item Image (with error handling)
          Image.asset(
            'assets/images/${item.imagePath}',
            width: 200,
            height: 200,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 200,
                height: 200,
                color: Colors.grey[700],
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.white,
                  size: 50,
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          // Item Name
          Text(
            item.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            item.description,
            style: const TextStyle(color: Colors.white70, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Optional: Add stats like "Rarity" or "Unlock Condition"
          _buildStatRow("Rarity", "★★★★☆"),
          _buildStatRow("Unlock Condition", "Beat Boss Rush"),
        ],
      ),
    );
  }

  // Helper widget for stats (optional)
  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
