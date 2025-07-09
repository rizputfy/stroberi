import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;
import 'services/history_service.dart';
import 'hasil_deteksi_page.dart';
import 'detail_deteksi_page.dart';

class DeteksiPage extends StatefulWidget {
  const DeteksiPage({super.key});

  @override
  State<DeteksiPage> createState() => _DeteksiPageState();
}

class _DeteksiPageState extends State<DeteksiPage> {
  File? _imageFile;
  String _result = '';
  String _currentLabel = '';
  bool _loading = false;

  late Interpreter _interpreter;
  List<String> _labels = [];
  final int _inputSize = 224;

  final Map<String, String> tipsPenyimpanan = {
    'Mentah': 'Simpan di suhu ruang dan hindari paparan sinar matahari langsung.',
    'Matang': 'Segera konsumsi atau simpan di lemari es untuk mempertahankan kesegaran.',
    'Busuk': 'Buang stroberi yang sudah busuk agar tidak mencemari stroberi lainnya.',
  };

  final Map<String, String> ciriCiriBuah = {
    'Mentah': 'Buah berwarna hijau pucat atau merah muda, tekstur keras.',
    'Matang': 'Berwarna merah cerah merata, tekstur lembut namun tidak lembek.',
    'Busuk': 'Terlihat lembek, mengeluarkan bau asam atau muncul jamur putih.',
  };

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

    final imageBytes = await picked.readAsBytes();
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

  Future<void> _runModel(img.Image image) async {
    final resizedImage = img.copyResize(image, width: _inputSize, height: _inputSize);
    final imageMatrix = imageToByteListFloat32(resizedImage, _inputSize);

    var output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);
    _interpreter.run(imageMatrix, output);

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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HasilDeteksiPage(
          imagePath: _imageFile!.path,
          label: label,
          confidence: confidence,
        ),
      ),
    );
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

  void _showTipsPopup() {
    if (_currentLabel.isEmpty || !tipsPenyimpanan.containsKey(_currentLabel)) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFEF5A6F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "TIPS MENYIMPAN BUAH STROBERI",
          style: TextStyle(
            color: Color(0xFFFCFDF2),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        content: Text(
          tipsPenyimpanan[_currentLabel]!,
          style: const TextStyle(color: Color(0xFFFCFDF2)),
        ),
        actions: [
          TextButton(
            child: const Text("Tutup", style: TextStyle(color: Color(0xFFFCFDF2))),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFDF2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEF5A6F),
        title: const Text("DETEKSI STROBERI", style: TextStyle(color: Color(0xFFFCFDF2))),
        iconTheme: const IconThemeData(color: Color(0xFFFCFDF2)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _imageFile != null
                  ? Image.file(_imageFile!, height: 300)
                  : Container(
                      height: 300,
                      color: Colors.grey[300],
                      child: const Center(child: Text("Belum ada gambar")),
                    ),
              const SizedBox(height: 16),
              const Text(
                "Tips: Gunakan gambar yang jelas dengan satu buah stroberi untuk hasil optimal",
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              _loading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        Text(
                          _result,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        if (_currentLabel.isNotEmpty && ciriCiriBuah.containsKey(_currentLabel))
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF5A6F),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "CIRI-CIRI BUAH STROBERI ${_currentLabel.toUpperCase()}",
                                  style: const TextStyle(
                                      color: Color(0xFFFCFDF2), fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  ciriCiriBuah[_currentLabel]!,
                                  style: const TextStyle(color: Color(0xFFFCFDF2)),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 12),
                        if (_currentLabel.isNotEmpty && tipsPenyimpanan.containsKey(_currentLabel))
                          ElevatedButton(
                            onPressed: _showTipsPopup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEF5A6F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Text("LIHAT TIPS PENYIMPANAN",
                                style: TextStyle(color: Color(0xFFFCFDF2))),
                          ),
                        const SizedBox(height: 12),
                        if (_currentLabel.isNotEmpty)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailDeteksiPage(label: _currentLabel),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEF5A6F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Text("LIHAT DETAIL", style: TextStyle(color: Color(0xFFFCFDF2))),
                          ),
                      ],
                    ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Kamera"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A827E),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Galeri"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A827E),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
