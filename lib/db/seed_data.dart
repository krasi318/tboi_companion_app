import 'package:flutter/services.dart' show rootBundle;
import 'package:tboi_companion_app/utils/image_to_hash.dart';
import 'database_helper.dart';
import '../models/item.dart';

class SeedData {
  static Future<void> insertInitialData() async {
    final db = DatabaseHelper.instance;

    final itemsData = [
      {
        'name': 'Brimstone',
        'description':
            'Blood laser barrage. Upon use, charges and fires a powerful blood laser in the direction the player is firing.',
        'assetImage': 'assets/images/brimstone.png',
      },
      {
        'name': 'The Inner Eye',
        'description':
            'Triple shot. Makes Isaac shoot 3 tears at once in a spread pattern.',
        'assetImage': 'assets/images/mushroom.png',
      },
    ];

    for (var data in itemsData) {
      try {
        final byteData = await rootBundle.load(data['assetImage']!);
        final bytes = byteData.buffer.asUint8List();

        final pixelHash = ImageUtils.imageToPixelHashFromBytes(bytes);

        final item = Item(
          name: data['name']!,
          description: data['description']!,
          imagePath: data['assetImage']!, // ✅ asset path
          pixelHash: pixelHash,
        );

        await db.insertItem(item);
        print('✅ Inserted ${data['name']}');
      } catch (e) {
        print('❌ Error processing ${data['name']}: $e');
      }
    }

    print('🎉 All seed data inserted!');
  }
}
