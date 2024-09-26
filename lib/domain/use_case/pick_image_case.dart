import 'dart:typed_data' show Uint8List;
import 'package:image_picker/image_picker.dart';

export 'dart:typed_data' show Uint8List;

// TBD: make as a class
mixin class PickImageCase {
  Future<({String name, Uint8List bytes})?> pickImage() async {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      // TBD: resize and convert by package:image
      maxWidth: 600,
    );
    return xFile == null
        ? null
        : (
            name: xFile.name,
            bytes: await xFile.readAsBytes(),
          );
  }
}
