import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tboi_companion_app/screens/item_detail_screen.dart';
import 'package:tboi_companion_app/utils/image_cropper.dart';
import 'package:tboi_companion_app/utils/image_handling.dart' as img_utils;
import '../utils/image_to_hash.dart';
import '../utils/hash_matcher.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isPermissionGranted = false;
  // ignore: unused_field
  File? _capturedImage;
  String? _capturedImageHash; // To store the hash of the captured image
  Uint8List? _croppedImageBytes;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera(cameraController.description);
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _isPermissionGranted = status == PermissionStatus.granted;
    });

    if (_isPermissionGranted) {
      _initializeCameraList();
    }
  }

  Future<void> _initializeCameraList() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        await _initializeCamera(_cameras.first);
      }
    } catch (e) {
      print('Error initializing cameras: $e');
    }
  }

  Future<void> _initializeCamera(CameraDescription cameraDescription) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    _controller = cameraController;

    try {
      await cameraController.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      // Take the picture
      final XFile photo = await _controller!.takePicture();

      // Get application documents directory
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String imageName = path.basename(photo.path);
      final String imagePath = path.join(appDir.path, imageName);

      // Copy the image to a new location
      final File newImage = File(imagePath);
      await File(photo.path).copy(newImage.path);

      // Load image bytes
      final imageBytes = await newImage.readAsBytes();

      // Crop the center rectangle from the image
      final croppedBytes = ImageCropper.cropCenterRect(
        imageBytes,
        cropWidthPercent: 0.4, // adjust as needed
        cropHeightPercent: 0.4,
      );

      // Generate pixel hash from the cropped image
      final pixelHash = ImageUtils.imageToPixelHashFromBytes(croppedBytes);

      setState(() {
        _capturedImage = newImage;
        _croppedImageBytes = croppedBytes;
        _capturedImageHash = pixelHash;
      });

      // Show dialog with the cropped image preview
      _showCapturedImageDialog();
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  void _showCapturedImageDialog() {
    if (_capturedImageHash != null) {
      print(
        '📸 Pixel Hash: $_capturedImageHash',
      ); //print hash for debug purposes
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2C2C2C),
            title: const Text(
              'Image Captured',
              style: TextStyle(color: Colors.white),
            ),
            content:
                _croppedImageBytes != null
                    ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 250,
                          height: 250,
                          child: Image.memory(_croppedImageBytes!),
                        ),
                        const SizedBox(height: 16),
                        // Text(
                        //   'Pixel Hash: $_capturedImageHash',
                        //   style: const TextStyle(color: Colors.white),
                        // ),
                      ],
                    )
                    : const Text(
                      'Failed to capture image',
                      style: TextStyle(color: Colors.white),
                    ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _capturedImage = null;
                    _croppedImageBytes = null;
                    _capturedImageHash = null;
                  });
                },
                child: const Text(
                  'Retake',
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  if (_capturedImageHash != null) {
                    final match = await HashMatcher.findClosestMatch(
                      _capturedImageHash!,
                      similarityThreshold: 0.7,
                    );

                    if (!mounted) return;

                    if (match != null) {
                      // Show match dialog with image + buttons
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              backgroundColor: const Color(0xFF2C2C2C),
                              title: const Text(
                                'Item Found',
                                style: TextStyle(color: Colors.white),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image(
                                    image: img_utils
                                        .ImageUtils.getImageProvider(
                                      match.imagePath,
                                    ),
                                    width: 100,
                                    height: 100,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.grey[700],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    match.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop(); // just close dialog
                                  },
                                  child: const Text(
                                    'Scan Another',
                                    style: TextStyle(color: Colors.deepPurple),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // close dialog
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) =>
                                                ItemDetailScreen(item: match),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    foregroundColor: Colors.black,
                                  ),
                                  child: const Text('View Item'),
                                ),
                              ],
                            ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('❌ No close match found.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  'Process',
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      appBar: AppBar(
        title: Text('Scan Item', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF2C2C2C),
      ),
      body:
          _isPermissionGranted ? _buildCameraView() : _buildPermissionRequest(),
    );
  }

  Widget _buildCameraView() {
    if (!_isCameraInitialized || _controller == null) {
      return Center(child: CircularProgressIndicator(color: Colors.deepPurple));
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Camera preview
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CameraPreview(_controller!),
        ),

        // Overlay for item framing
        Center(
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.deepPurple, width: 2.0),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // Capture button at the bottom
        Positioned(
          bottom: 40,
          child: FloatingActionButton(
            backgroundColor: Colors.deepPurple,
            onPressed: _captureImage,
            child: Icon(Icons.camera, size: 32),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionRequest() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.camera_alt, color: Colors.grey, size: 100),
          SizedBox(height: 24),
          Text(
            'Camera permission is required\nto scan items',
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: _requestCameraPermission,
            child: Text('Grant Permission'),
          ),
        ],
      ),
    );
  }
}
