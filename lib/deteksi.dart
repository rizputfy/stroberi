import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;

import 'services/history_service.dart';
import 'hasil_deteksi_page.dart';
import 'theme.dart';

class DeteksiPage extends StatefulWidget {
  const DeteksiPage({Key? key}) : super(key: key);

  @override
  State<DeteksiPage> createState() => _DeteksiPageState();
}

class _DeteksiPageState extends State<DeteksiPage> {
  File? _imageFile;
  bool _loading = false;
  String _currentLabel = '';

  late Interpreter _interpreter;
  List<String> _labels = [];
  final int _inputSize = 224;

  @override
  void initState() {
    super.initState();
    _loadModelAndLabels();
  }

  Future<void> _loadModelAndLabels() async {
    try {
      _interpreter = await Interpreter.fromAsset('model_mobile.tflite');
      final rawLabels = await rootBundle.loadString('assets/labels.txt');
      setState(() {
        _labels = rawLabels.split('\n').where((e) => e.trim().isNotEmpty).toList();
      });
      debugPrint("✅ Model dan label berhasil dimuat.");
    } catch (e) {
      debugPrint("❌ Gagal memuat model/label: $e");
      setState(() {
        _labels = [];
      });
    }
  }

  Uint8List imageToByteListFloat32(img.Image image, int inputSize) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        final pixel = image.getPixel(x, y);
        buffer[pixelIndex++] = (img.getRed(pixel)) / 255.0;
        buffer[pixelIndex++] = (img.getGreen(pixel)) / 255.0;
        buffer[pixelIndex++] = (img.getBlue(pixel)) / 255.0;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _currentLabel = '';
      });
    }
  }

  Future<void> _runModel(img.Image image) async {
    final resizedImage = img.copyResize(image, width: _inputSize, height: _inputSize);
    final imageMatrix = imageToByteListFloat32(resizedImage, _inputSize);

    var input = imageMatrix.buffer.asUint8List();
    var output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);
    _interpreter.run(input, output);

    final List<double> prediction = List<double>.from(output[0]);
    final double maxValue = prediction.reduce((a, b) => a > b ? a : b);
    final int resultIndex = prediction.indexOf(maxValue);
    final double confidence = prediction[resultIndex] * 100;
    final String label = _labels[resultIndex];

    if (!mounted) return;

    setState(() {
      _currentLabel = label;
      _loading = false;
    });

    await HistoryService().saveDetection(
      imagePath: _imageFile!.path,
      label: label,
      confidence: confidence,
    );

    if (!context.mounted) return;
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HasilDeteksiPage(
            imagePath: _imageFile!.path,
            label: label,
            confidence: confidence,
          ),
        ),
      );

      // Setelah kembali dari HasilDeteksiPage, reset state
      if (mounted) {
        setState(() {
          _imageFile = null;
          _currentLabel = '';
          _loading = false;
        });
}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          "DETEKSI STROBERI",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30), bottom: Radius.circular(30)),
            ),
            child: Column(
              children: [
                const Text(
                  "Unggah gambar stroberi dari galeri atau ambil langsung dari kamera untuk mendeteksi tingkat kematangan.",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _getImage(ImageSource.gallery),
                      icon: const Icon(Icons.image),
                      label: const Text("Galeri"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _getImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text("Kamera"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: _imageFile == null
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          "Belum ada gambar dipilih.",
                          style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: FileImage(_imageFile!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ),
          ),
          if (_currentLabel.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                "Hasil Deteksi: $_currentLabel",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: ElevatedButton(
              onPressed: () async {
                if (_imageFile == null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Gambar belum dipilih"),
                        content: const Text("Silakan unggah atau ambil gambar terlebih dahulu sebelum melakukan deteksi."),
                        actions: [
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }

                setState(() {
                  _loading = true;
                });

                final imageBytes = await _imageFile!.readAsBytes();
                final image = img.decodeImage(imageBytes);
                if (image != null) {
                  await _runModel(image);
                } else {
                  setState(() {
                    _loading = false;
                  });
                }
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[200],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: const Text(
                "CEK PREDIKSI",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
