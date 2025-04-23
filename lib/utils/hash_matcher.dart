import 'package:tboi_companion_app/db/database_helper.dart';
import '../models/item.dart';

/// Provides functionality to find item matches based on pixel hashes.
class HashMatcher {
  static Future<Item?> findClosestMatch(
    String capturedHash, {
    double similarityThreshold = 0.75,
  }) async {
    final db = DatabaseHelper.instance;
    final items = await db.getAllItems();

    Item? bestMatch;
    double bestSimilarity = 0.0;

    for (final item in items) {
      final similarity = _calculateSimilarity(
        capturedHash,
        item.pixelHash ?? '',
      );

      if (similarity > bestSimilarity && similarity >= similarityThreshold) {
        bestSimilarity = similarity;
        bestMatch = item;
      }
    }

    return bestMatch;
  }

  static double _calculateSimilarity(String a, String b) {
    if (a.length != b.length) return 0.0;

    int matches = 0;
    for (int i = 0; i < a.length; i++) {
      if (a[i] == b[i]) {
        matches++;
      }
    }
    return matches / a.length;
  }
}

Future<Item?> findClosestMatch(
  String capturedHash, {
  int maxDistance = 10,
}) async {
  final db = DatabaseHelper.instance;
  final items = await db.getAllItems();

  Item? closestItem;
  int closestDistance = maxDistance + 1;

  for (final item in items) {
    final distance = _hammingDistance(
      capturedHash,
      item.pixelHash ?? '30 red ne bachka',
    );
    if (distance < closestDistance) {
      closestDistance = distance;
      closestItem = item;
    }
  }

  return closestDistance <= maxDistance ? closestItem : null;
}

/// Calculates the Hamming distance between two strings.
int _hammingDistance(String a, String b) {
  if (a.length != b.length) {
    return a.length > b.length ? a.length : b.length;
  }

  int distance = 0;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      distance++;
    }
  }
  return distance;
}
