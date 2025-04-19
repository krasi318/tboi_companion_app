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
      // {
      //   'name': 'Brimstone',
      //   'description':
      //       'Blood laser barrage. Upon use, charges and fires a powerful blood laser in the direction the player is firing.',
      //   'assetImage': 'assets/images/brimstone.png',
      // },
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
      {
        'name': 'Phd',
        'description':
            'Changes the effects of all negative Pills to their positive counterparts.',
        'assetImage': 'assets/images/phd.png',
      },
      {
        'name': 'Deck of cards',
        'description': 'Active item that gives Isaac a random card or rune.',
        'assetImage': 'assets/images/deck-of-cards.png',
        'pixelHash':
            '1000000000000000000000000000000011111111111111111111111111111111000000000000000000000000000000001111111111111111111111111111111100000000000000000000000000000011111111111111111111111111111111110000000000000000000000000000011111111111111111111111111111111111000000000000000000000000000000111111111111111111111111111111111100000000000000000000000000001111111111111111111111111111111111110000000000000000000000000100111111111111111111111111111111111111000000000000000000000000011111111111111111111111111111111111111100000000000000000000011111111111111111111111111111101111111111110000000000000000000000111111111111111110000000000000000001111111000000000000000000000000000000000000000000000000000000000011111100000000000000000000000000000000000000000000000000000000000111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',
        //testing with this one
      },
      {
        'name': 'Demon Baby',
        'description':
            'Passive item that spawns a familiar that shoots tears at enemies.',
        'assetImage': 'assets/images/demon-baby.png',
      },
      {
        'name': 'Punching Bag',
        'description':
            'Passive item that spawns a familiar that distracts enemies.',
        'assetImage': 'assets/images/punching-bag.png',
      },
      {
        'name': 'Dads Key',
        'description':
            'Active item that unlocks all doors in the current room.',
        'assetImage': 'assets/images/dads-key.png',
      },
      {
        'name': 'Odd Mushroom',
        'description':
            'Passive item that increases Isaac\'s damage and tears rate.',
        'assetImage': 'assets/images/odd-mushroom.png',
      },
    ];

    for (var data in itemsData) {
      try {
        String pixelHash;

        if (data.containsKey('pixelHash') && data['pixelHash']!.isNotEmpty) {
          pixelHash = data['pixelHash']!;
          print('ℹ️ Using manual hash for ${data['name']}: $pixelHash');
        } else {
          final byteData = await rootBundle.load(data['assetImage']!);
          final bytes = byteData.buffer.asUint8List();
          pixelHash = ImageUtils.imageToPixelHashFromBytes(bytes);
          print('⚙️ Generated hash for ${data['name']}: $pixelHash');
        }

        final item = Item(
          name: data['name']!,
          description: data['description']!,
          imagePath: data['assetImage']!,
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
