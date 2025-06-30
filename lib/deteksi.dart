import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle; 
import 'models/history_item.dart';
import 'services/history_service.dart';

class DeteksiPage extends StatefulWidget {
  const DeteksiPage({super.key});

  @override
  State<DeteksiPage> createState() => _DeteksiPageState();
}

class _DeteksiPageState extends State<DeteksiPage> {
  File? _imageFile;
  String _result = '';
  bool _loading = false;

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

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked == null) return;

    setState(() {
      _imageFile = File(picked.path);
      _result = '';
      _loading = true;
    });

    final imageBytes = File(picked.path).readAsBytesSync();
    final image = img.decodeImage(imageBytes);

    if (image != null) {
      _runModel(image);
    } else {
      setState(() {
        _result = 'Gagal memproses gambar.';
        _loading = false;
      });
    }
  }

  void _runModel(img.Image image) {
  final resizedImage = img.copyResize(image, width: _inputSize, height: _inputSize);
  final imageMatrix = imageToByteListFloat32(resizedImage, _inputSize);

  var output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);
  _interpreter.run(imageMatrix, output);

  final List<double> prediction = List<double>.from(output[0]);
  final double maxValue = prediction.reduce((a, b) => a > b ? a : b);
  final int resultIndex = prediction.indexOf(maxValue);
  final confidence = (prediction[resultIndex] * 100).toStringAsFixed(2);
  final label = _labels[resultIndex];

  setState(() {
    _result = 'Kelas: $label\nKepercayaan: $confidence%';
    _loading = false;
  });

  HistoryService.addHistory(HistoryItem(
    label: label,
    confidence: confidence,
    dateTime: DateTime.now(),
    imagePath: _imageFile!.path,
  ));
}


  Uint8List imageToByteListFloat32(img.Image image, int inputSize) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var y = 0; y < inputSize; y++) {
      for (var x = 0; x < inputSize; x++) {
        var pixel = image.getPixel(x, y);
        buffer[pixelIndex++] = (img.getRed(pixel)) / 255.0;
        buffer[pixelIndex++] = (img.getGreen(pixel)) / 255.0;
        buffer[pixelIndex++] = (img.getBlue(pixel)) / 255.0;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Deteksi Kematangan Stroberi")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _imageFile != null
                ? Image.file(_imageFile!, height: 250)
                : Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: const Center(child: Text("Belum ada gambar")),
                  ),
            const SizedBox(height: 16),
            _loading
                ? const CircularProgressIndicator()
                : Text(
                    _result,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Kamera"),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Galeri"),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
