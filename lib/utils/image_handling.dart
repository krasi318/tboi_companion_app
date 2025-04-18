import 'dart:io';
import 'package:flutter/material.dart';

class ImageUtils {
  static ImageProvider getImageProvider(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    } else {
      return FileImage(File(imagePath));
    }
  }
}
