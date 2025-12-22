import 'dart:typed_data';
import 'package:avatar/core/utils/router/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class LivenessDetectionPage extends StatefulWidget {
  const LivenessDetectionPage({super.key});

  @override
  _LivenessDetectionPageState createState() => _LivenessDetectionPageState();
}

class _LivenessDetectionPageState extends State<LivenessDetectionPage> {
  CameraController? _cameraController;
  CameraDescription? _frontCamera;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  bool _isProcessing = false;
  bool _blinkDetected = false;
  String _instructionText = "Align your face in the frame";
  int _frameCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _frontCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        _frontCamera!,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420, // آمن للأجهزة
      );

      await _cameraController!.initialize();
      if (!mounted) return;

      _cameraController!.startImageStream((image) async {
        _frameCount++;
        if (!_isProcessing && _frameCount % 3 == 0) {
          _isProcessing = true;
          try {
            final inputImage = _convertCameraImage(image, _frontCamera!);
            final faces = await _faceDetector.processImage(inputImage);
            _handleFaces(faces);
          } catch (e) {
            debugPrint("Face detection error: $e");
          }
          _isProcessing = false;
        }
      });

      setState(() {});
    } catch (e) {
      debugPrint("Camera initialization error: $e");
    }
  }

  InputImage _convertCameraImage(CameraImage image, CameraDescription camera) {
    try {
      final allBytes = image.planes.fold<Uint8List>(
        Uint8List(0),
        (previousValue, element) => Uint8List.fromList(previousValue + element.bytes),
      );

      final imageSize = Size(image.width.toDouble(), image.height.toDouble());

      final rotation = camera.lensDirection == CameraLensDirection.front
          ? InputImageRotation.rotation270deg
          : InputImageRotation.rotation90deg;

      final inputImageData = InputImageMetadata(
        size: imageSize,
        rotation: rotation,
        format: InputImageFormat.yuv420, // يوافق أغلب الأجهزة
        bytesPerRow: image.planes[0].bytesPerRow,
      );

      return InputImage.fromBytes(bytes: allBytes, metadata: inputImageData);
    } catch (e, s) {
      debugPrint("Failed to convert CameraImage to InputImage: $e");
      debugPrint("$s");
      rethrow;
    }
  }

  void _handleFaces(List<Face> faces) {
    if (faces.isEmpty) {
      setState(() => _instructionText = "No face detected. Please show your face");
      return;
    }

    bool humanFaceDetected = false;

    for (Face face in faces) {
      final leftEyeOpen = face.leftEyeOpenProbability;
      final rightEyeOpen = face.rightEyeOpenProbability;

      if (leftEyeOpen == null || rightEyeOpen == null) continue;

      humanFaceDetected = true;

      if (leftEyeOpen < 0.2 && rightEyeOpen < 0.2) {
        _blinkDetected = true;
      }

      if (_blinkDetected && leftEyeOpen > 0.6 && rightEyeOpen > 0.6) {
        setState(() => _instructionText = "Verification Complete! ✅");
        _onSuccess();
        return;
      }
    }

    if (!humanFaceDetected) {
      setState(() => _instructionText = "Not a human face detected ❌");
    } else if (!_blinkDetected) {
      setState(() => _instructionText = "Please blink your eyes");
    }
  }

  void _onSuccess() {
    _cameraController?.stopImageStream();
    Future.delayed(const Duration(milliseconds: 800), () {
      GoRouter.of(context).go(RoutesName.logIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: CameraPreview(_cameraController!)),
          _buildScanningOverlay(),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  _instructionText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                if (!_blinkDetected)
                  const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.blueAccent,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningOverlay() {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.srcOut),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              backgroundBlendMode: BlendMode.dstOut,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 350,
              width: 260,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.elliptical(260, 350)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }
}
