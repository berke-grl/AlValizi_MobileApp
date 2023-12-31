import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:graduation_app/screens/translate_result_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class TranslateTextCameraRecognition extends StatefulWidget {
  const TranslateTextCameraRecognition({super.key});

  @override
  State<TranslateTextCameraRecognition> createState() =>
      _TranslateTextCameraRecognitionState();
}

class _TranslateTextCameraRecognitionState
    extends State<TranslateTextCameraRecognition> with WidgetsBindingObserver {
  bool _isPermissionGranted = false;

  late final Future<void> _future;
  CameraController? _cameraController;
  final _textRecognizer = TextRecognizer();

  //methods
  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }
    //Select the first rare camera
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }
    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController =
        CameraController(camera, ResolutionPreset.max, enableAudio: false);

    await _cameraController?.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  Future<void> _scanImage() async {
    if (_cameraController == null) return;

    final navigator = Navigator.of(context);

    try {
      final pictureFile = await _cameraController!.takePicture();

      final file = File(pictureFile.path);
      final inputImage = InputImage.fromFile(file);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      await navigator.push(
        MaterialPageRoute(
          builder: (context) =>
              TranslateResultScreen(text: recognizedText.text),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occured when scaning text"),
        ),
      );
    }
  }
  //end of the methods

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _future = _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _startCamera();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (_cameraController == null || _cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _startCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return Stack(
          children: [
            if (_isPermissionGranted)
              FutureBuilder<List<CameraDescription>>(
                future: availableCameras(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _initCameraController(snapshot.data!);
                    return Center(
                      child: CameraPreview(_cameraController!),
                    );
                  } else {
                    return const LinearProgressIndicator();
                  }
                },
              ),
            Scaffold(
              appBar: AppBar(
                title: const Text("Text Recognition Example"),
                backgroundColor: Colors.green,
              ),
              backgroundColor: _isPermissionGranted ? Colors.transparent : null,
              body: SafeArea(
                child: _isPermissionGranted
                    ? Column(
                        children: [
                          Expanded(
                            child: Container(),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: _scanImage,
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  side: const BorderSide(
                                      color: Colors.green, width: 2),
                                ),
                                child: const Text("Scan Text"),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Container(
                          padding: const EdgeInsets.only(left: 24, right: 24),
                          child: const Text(
                            "Camera Permission Denied",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
