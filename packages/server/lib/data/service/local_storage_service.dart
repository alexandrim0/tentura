import 'dart:io';
import 'dart:developer';
import 'dart:typed_data';
import 'package:injectable/injectable.dart';

@injectable
class LocalStorageService {
  const LocalStorageService();

  Future<void> saveBytesToFile(Uint8List imageBytes, File file) async {
    IOSink? sink;
    try {
      file.parent.createSync(recursive: true);
      sink = file.openWrite()..add(imageBytes);
      await sink.flush();
    } catch (e) {
      log(e.toString());
      rethrow;
    } finally {
      await sink?.close();
    }
  }

  Future<void> saveStreamToFile(Stream<List<int>> stream, File file) async {
    IOSink? sink;
    try {
      file.parent.createSync(recursive: true);
      sink = file.openWrite();
      await sink.addStream(stream);
      await sink.flush();
    } catch (e) {
      log(e.toString());
      rethrow;
    } finally {
      await sink?.close();
    }
  }
}
