import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'utils/image_to_hash.dart'; // Import the image_to_hash.dart utility

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isPermissionGranted = false;
  File? _capturedImage;
  String? _capturedImageHash; // To store the hash of the captured image

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

      // Copy the image to a new location with a timestamped name
      final File newImage = File(imagePath);
      await File(photo.path).copy(newImage.path);

      setState(() {
        _capturedImage = newImage;
      });

      // Generate pixel hash using image_to_hash.dart utility
      _capturedImageHash = await ImageUtils.imageToPixelHash(newImage.path);

      // Show the captured image along with the hash
      _showCapturedImageDialog();
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  void _showCapturedImageDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Color(0xFF2C2C2C),
            title: Text(
              'Image Captured',
              style: TextStyle(color: Colors.white),
            ),
            content:
                _capturedImage != null
                    ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 250,
                          height: 250,
                          child: Image.file(_capturedImage!),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Pixel Hash: $_capturedImageHash', // Show the hash
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )
                    : Text(
                      'Failed to capture image',
                      style: TextStyle(color: Colors.white),
                    ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _capturedImage = null; // Reset captured image
                    _capturedImageHash = null; // Reset hash
                  });
                },
                child: Text(
                  'Retake',
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Image processing will be implemented in the future',
                      ),
                    ),
                  );
                },
                child: Text(
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
        title: Text('Scan Item'),
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
        Container(
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
