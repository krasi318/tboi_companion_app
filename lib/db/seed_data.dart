import 'package:flutter/services.dart' show rootBundle;
import 'package:tboi_companion_app/utils/image_to_hash.dart';
import 'database_helper.dart';
import '../models/item.dart';

class SeedData {
  static Future<void> insertInitialData() async {
    final db = DatabaseHelper.instance;

    final itemsData = [
      {
        'name': 'The Inner Eye',
        'description':
            'Triple shot. Makes Isaac shoot 3 tears at once in a spread pattern.',
        'assetImage': 'assets/images/mushroom.png',
      },
      {
        'name': 'Brimstone',
        'description':
            'Blood laser barrage. Upon use, charges and fires a powerful blood laser in the direction the player is firing.',
        'assetImage': 'assets/images/brimstone.png',
      },
      {
        'name': 'Soy Milk',
        'description':
            'Tears are replaced with a rapid fire of small tears. Damage is significantly reduced.',
        'assetImage': 'assets/images/soy-milk.png',
      },
      {
        'name': 'Monstros Lung',
        'description':
            'Tears are charged and shot through a large barrel. The tears are charged and shot in a spread pattern.',
        'assetImage': 'assets/images/monstros-lung.png',
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
