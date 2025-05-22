import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/entity/image_entity.dart';

export 'package:image_picker/image_picker.dart' show XFile;

@injectable
class ImageRepository {
  final _imagePicker = ImagePicker();

  Future<ImageEntity?> pickImage() async {
    final maxDimension = kImageMaxDimension.toDouble();
    final xFile = await _imagePicker.pickImage(
      maxHeight: maxDimension,
      maxWidth: maxDimension,
      source: ImageSource.gallery,
    );
    return xFile == null
        ? null
        : switch (xFile.name.toLowerCase()) {
          _ when xFile.name.endsWith('.jpg') || xFile.name.endsWith('.jpeg') =>
            ImageEntity(
              imageBytes: await xFile.readAsBytes(),
              fileName: xFile.name,
            ),

          _ when xFile.name.endsWith('.png') => ImageEntity(
            imageBytes: img.encodeJpg(
              img.decodePng(await xFile.readAsBytes()) ??
                  (throw const FormatException('Cant decode image')),
            ),
            fileName: xFile.name,
          ),

          _ when xFile.name.endsWith('.webp') => ImageEntity(
            imageBytes: img.encodeJpg(
              img.decodeWebP(await xFile.readAsBytes()) ??
                  (throw const FormatException('Cant decode image')),
            ),
            fileName: xFile.name,
          ),

          // Try to decode other formats (may be much slower)
          _ => ImageEntity(
            imageBytes: img.encodeJpg(
              img.decodeImage(await xFile.readAsBytes()) ??
                  (throw const FormatException('Cant decode image')),
            ),
            fileName: xFile.name,
          ),
        };
  }
}
