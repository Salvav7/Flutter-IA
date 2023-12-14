import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:math';

class DocumentScannerPage extends StatefulWidget {
  const DocumentScannerPage({Key? key}) : super(key: key);

  @override
  _DocumentScannerPageState createState() => _DocumentScannerPageState();
}

class _DocumentScannerPageState extends State<DocumentScannerPage> {
  CameraController? _cameraController;
  XFile? _capturedImage;
  bool _isVerifying = false;

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(camera, ResolutionPreset.medium);
    await _cameraController!.initialize();

    setState(() {});
  }

  Future<void> _takePhoto() async {
    final image = await _cameraController!.takePicture();

    setState(() {
      _capturedImage = image;
    });
  }

  Future<List<List<List<List<int>>>>> _resizeImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final uint8List = Uint8List.fromList(bytes);

    final reshapedImage =
        _reshapeImage(uint8List, height: 150, width: 150, channels: 3);

    return reshapedImage;
  }

  List<List<List<List<int>>>> _reshapeImage(Uint8List imageBytes,
      {required int height, required int width, required int channels}) {
    final reshapedImage = List.generate(
      1,
      (i) => List.generate(
        height,
        (j) => List.generate(
          width,
          (k) => List.generate(
            channels,
            (l) => imageBytes[(j * width * channels) + (k * channels) + l],
          ),
        ),
      ),
    );

    return reshapedImage;
  }

  Future<void> _verifyPhoto(
      List<List<List<List<int>>>> resizedImageBytes) async {
    if (_capturedImage == null) {
      Fluttertoast.showToast(msg: 'Por favor, toma o selecciona una foto');
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    try {
      const url =
          'https://bernardoerick-model-service-bernarm111.cloud.okteto.net/v1/models/bernardoerick-model:predict';

      List<List<List<List<int>>>> instances = resizedImageBytes;
      final Map<String, dynamic> predictionInstance = {'instances': instances};

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(predictionInstance),
      );

      final jsonResponse = response.body;
      if (response.statusCode == 200) {
        print('Response from server: ${response.body}');

        final predictions = jsonDecode(jsonResponse)['predictions'];
        final score = (predictions[0] as List<dynamic>)[0] as double;
        final confidence = (1 - score) * 100;

        String personName;
        if (confidence > 50) {
          personName = 'Bernardo';
        } else {
          personName = 'Erick';
        }

        print('Se reconoce: $personName con una confianza del $confidence%');
      

        Fluttertoast.showToast(
            msg:
            ("This image is ${(100 * (1 - score)).toStringAsFixed(2)}% bernardo and ${(100 * score).toStringAsFixed(2)}% erick.")
);
      } else {
        print('No se pudo reconocer el rostro. Respuesta: $jsonResponse');
        Fluttertoast.showToast(msg: 'No se pudo reconocer el rostro');
      }
    } catch (error) {
      print('Error en la solicitud: $error');
      Fluttertoast.showToast(msg: 'Error en la solicitud: $error');
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  Future<void> _pickPhotoFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      final resizedImageBytes = await _resizeImage(File(image.path));
      await _verifyPhoto(resizedImageBytes);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    );
    return Scaffold(
      body: Stack(
        children: [
          if (_cameraController != null &&
              _cameraController!.value.isInitialized)
            Positioned.fill(
              child: AspectRatio(
                aspectRatio: _cameraController!.value.aspectRatio,
                child: CameraPreview(_cameraController!),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              color: Colors.black.withOpacity(0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(0, 255, 255, 255)
                          .withOpacity(0.7),
                    ),
                    child: IconButton(
                      onPressed: _pickPhotoFromGallery,
                      icon: Icon(Icons.photo),
                      iconSize: 32.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 32.0),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                    child: IconButton(
                      onPressed: _takePhoto,
                      icon: Icon(Icons.camera_alt),
                      iconSize: 64.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 32.0),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    child: _isVerifying
                        ? CircularProgressIndicator()
                        : IconButton(
                            onPressed: () async {
                              await _verifyPhoto(await _resizeImage(
                                  File(_capturedImage!.path)));
                            },
                            icon: Icon(Icons.check),
                            iconSize: 23.0,
                            color: Colors.black,
                          ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _initializeCamera();
                },
                child: Text('Abrir cámara'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
