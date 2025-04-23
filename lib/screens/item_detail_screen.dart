import 'package:flutter/material.dart';
import 'package:tboi_companion_app/utils/image_handling.dart';
import '../models/item.dart';

class ItemDetailScreen extends StatelessWidget {
  final Item item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: Text(item.name, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2C2C2C),
        iconTheme: const IconThemeData(color: Colors.white),
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
          Image(
            image: ImageUtils.getImageProvider(item.imagePath),
            fit: BoxFit.cover,
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
          _buildStatRow("Редкост", "★★★☆"),
          _buildStatRow("Условие за отключване", "Победи Boss Rush"),
          const SizedBox(height: 24),
          // Pixel Hash
          Text(
            'Pixel Hash: ${item.pixelHash ?? 'Няма информация'}',
            style: const TextStyle(color: Colors.white70, fontSize: 14.0),
            textAlign: TextAlign.center,
          ),
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
