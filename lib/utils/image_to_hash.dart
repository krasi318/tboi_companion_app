import 'dart:io';
import 'package:image/image.dart' as img;

class ImageUtils {
  // Convert an image to a pixel hash
  static String imageToPixelHash(String imagePath) {
    final image = img.decodeImage(File(imagePath).readAsBytesSync());

    if (image == null) {
      throw Exception("Failed to load image");
    }

    // Resize image to a smaller size for hashing (optional)
    final resizedImage = img.copyResize(image, width: 16, height: 16);

    String pixelHash = '';
    for (int y = 0; y < resizedImage.height; y++) {
      for (int x = 0; x < resizedImage.width; x++) {
        final pixel = resizedImage.getPixel(x, y);

        // Extracting RGB values directly
        final int red = img.getRed(pixel);
        final int green = img.getGreen(pixel);
        final int blue = img.getBlue(pixel);

        // Calculate the brightness (average RGB value)
        final int brightness = (red + green + blue) ~/ 3;

        // Generate pixel hash (1 for bright, 0 for dark)
        pixelHash += brightness > 128 ? '1' : '0';
      }
    }

    return pixelHash;
  }

  // Compare two pixel hashes
  static bool comparePixelHashes(String hash1, String hash2) {
    int matchCount = 0;
    for (int i = 0; i < hash1.length; i++) {
      if (hash1[i] == hash2[i]) {
        matchCount++;
      }
    }

    double matchPercentage = (matchCount / hash1.length) * 100;
    return matchPercentage >= 80;
  }
}
