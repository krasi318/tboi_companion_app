import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageUtils {
  // Original: From file path
  static String imageToPixelHash(String path) {
    final image = img.decodeImage(File(path).readAsBytesSync());
    return _hashFromImage(image);
  }

  static String imageToPixelHashFromBytes(Uint8List bytes) {
    final image = img.decodeImage(bytes);
    return _hashFromImage(image);
  }

  static String _hashFromImage(img.Image? image) {
    if (image == null) return '';

    final resized = img.copyResize(image, width: 128, height: 128);
    String hash = '';
    for (int y = 0; y < resized.height; y++) {
      for (int x = 0; x < resized.width; x++) {
        final pixel = resized.getPixel(x, y);
        final r = img.getRed(pixel);
        final g = img.getGreen(pixel);
        final b = img.getBlue(pixel);
        final brightness = (r + g + b) ~/ 3;
        hash += brightness > 128 ? '1' : '0';
      }
    }
    return hash;
  }
}
