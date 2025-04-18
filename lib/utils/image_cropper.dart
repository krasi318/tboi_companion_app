import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageCropper {
  /// Crops the center rectangle from image bytes based on given [cropWidthPercent] and [cropHeightPercent].
  static Uint8List cropCenterRect(
    Uint8List imageBytes, {
    double cropWidthPercent = 0.5,
    double cropHeightPercent = 0.5,
  }) {
    final original = img.decodeImage(imageBytes);
    if (original == null) throw Exception('❌ Failed to decode image');

    final cropWidth = (original.width * cropWidthPercent).toInt();
    final cropHeight = (original.height * cropHeightPercent).toInt();

    final startX = ((original.width - cropWidth) / 2).toInt();
    final startY = ((original.height - cropHeight) / 2).toInt();

    final cropped = img.copyCrop(
      original,
      startX,
      startY,
      cropWidth,
      cropHeight,
    );
    return Uint8List.fromList(img.encodePng(cropped));
  }
}
