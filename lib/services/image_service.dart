import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

Future<String> savePermanentCopy(File imageFile, {int maxSize = 512}) async {
  final bytes = await imageFile.readAsBytes();
  final decoded = img.decodeImage(bytes);

  if (decoded == null) throw Exception("Gagal decode gambar.");

  final resized = img.copyResize(decoded, width: maxSize);

  final dir = await getApplicationDocumentsDirectory();
  final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
  final newPath = '${dir.path}/$fileName';

  final newFile = File(newPath)..writeAsBytesSync(img.encodeJpg(resized, quality: 85));
  return newFile.path;
}
