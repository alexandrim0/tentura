import 'dart:io';
import 'dart:developer';
import 'dart:typed_data';
import 'package:injectable/injectable.dart';

@singleton
class LocalStorageService {
  const LocalStorageService();

  Future<Uint8List> readFile(String path) => File(path).readAsBytes();

  Future<void> saveBytesToFile(Uint8List bytes, File file) async {
    IOSink? sink;
    try {
      file.parent.createSync(recursive: true);
      sink = file.openWrite()..add(bytes);
      await sink.flush();
    } catch (e) {
      log(e.toString());
      rethrow;
    } finally {
      await sink?.close();
    }
  }

  Future<String> saveStreamToFile(String path, Stream<Uint8List> stream) async {
    IOSink? sink;
    try {
      final file = File(path);
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
    // TBD: calculate E-Tag
    return '';
  }

  Future<void> deleteFile(String path, {bool recursive = false}) =>
      File(path).delete(recursive: recursive);
}
