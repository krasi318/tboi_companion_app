import 'package:tboi_companion_app/utils/image_to_hash.dart';

import 'database_helper.dart';
import '../models/item.dart';

class SeedData {
  static Future<void> insertInitialData() async {
    final db = DatabaseHelper.instance;

    // List of items from Binding of Isaac
    final items = [
      Item(
        name: 'Brimstone',
        description:
            'Blood laser barrage. Upon use, charges and fires a powerful blood laser in the direction the player is firing.',
        imagePath: 'brimstone.png',
        pixelHash: '', // Empty initially, will be populated later
      ),
      Item(
        name: 'The Inner Eye',
        description:
            'Triple shot. Makes Isaac shoot 3 tears at once in a spread pattern.',
        imagePath: 'inner_eye.png',
        pixelHash: '', // Empty initially, will be populated later
      ),
      Item(
        name: 'Sacred Heart',
        description:
            'Homing tears + DMG up. Tears gain homing ability and a significant damage up.',
        imagePath: 'sacred_heart.png',
        pixelHash: '', // Empty initially, will be populated later
      ),
      Item(
        name: 'Tech X',
        description:
            'Laser rings. Allows Isaac to charge and fire laser rings that deal continuous damage.',
        imagePath: 'tech_x.png',
        pixelHash: '', // Empty initially, will be populated later
      ),
      Item(
        name: 'Godhead',
        description:
            'Homing tears + damaging aura. Tears gain homing ability and are surrounded by a damaging aura.',
        imagePath: 'godhead.png',
        pixelHash: '', // Empty initially, will be populated later
      ),
      Item(
        name: 'Polyphemus',
        description:
            'Massive tears. Greatly increases tear damage but decreases tear rate.',
        imagePath: 'polyphemus.png',
        pixelHash: '', // Empty initially, will be populated later
      ),
      Item(
        name: '20/20',
        description:
            'Double shot. Isaac fires two tears at once instead of one.',
        imagePath: '20_20.png',
        pixelHash: '', // Empty initially, will be populated later
      ),
      Item(
        name: 'Mom\'s Knife',
        description:
            'Stab + throw. Replaces tears with a knife that can be thrown and deals continuous damage.',
        imagePath: 'moms_knife.png',
        pixelHash: '', // Empty initially, will be populated later
      ),
      Item(
        name: 'Cricket\'s Head',
        description: 'DMG up. Increases Isaac\'s damage by approximately 50%.',
        imagePath: 'crickets_head.png',
        pixelHash: '', // Empty initially, will be populated later
      ),
      Item(
        name: 'Holy Mantle',
        description:
            'Protective shield. Negates a single hit of damage per room.',
        imagePath: 'holy_mantle.png',
        pixelHash: '', // Empty initially, will be populated later
      ),
    ];

    // Insert each item into the database
    for (var item in items) {
      // Generate pixel hash for each item using the image path
      String pixelHash = await ImageUtils.imageToPixelHash(item.imagePath);

      // Now update the item with the generated pixelHash
      final itemWithHash = Item(
        name: item.name,
        description: item.description,
        imagePath: item.imagePath,
        pixelHash: pixelHash, // Add the pixelHash here
      );

      // Insert the item with the hash into the database
      await db.insertItem(itemWithHash);
    }
  }
}
