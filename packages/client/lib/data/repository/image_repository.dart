import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/data/service/remote_api_service.dart';
import 'package:tentura/domain/entity/image_entity.dart';

export 'package:image_picker/image_picker.dart' show XFile;

@injectable
class ImageRepository {
  ImageRepository(this._remoteApiService);

  final RemoteApiService _remoteApiService;

  Future<ImageEntity?> pickImage() async {
    final maxDimension = kImageMaxDimension.toDouble();
    final xFile = await _imagePicker.pickImage(
      maxHeight: maxDimension,
      maxWidth: maxDimension,
      source: ImageSource.gallery,
    );
    return xFile == null
        ? null
        : ImageEntity(
          imageBytes: await xFile.readAsBytes(),
          mimeType: xFile.mimeType ?? 'image/jpeg',
          fileName: xFile.name,
        );
  }

  Future<void> uploadImage({
    required ImageEntity image,
    required String imageId,
  }) async {
    final jwt = await _remoteApiService.getAuthToken();
    await post(
      Uri.parse('$kServerName/$kPathImageUpload?id=$imageId'),
      headers: {
        kHeaderUserAgent: kUserAgent,
        kHeaderContentType: kContentTypeJpeg,
        kHeaderAuthorization: 'Bearer ${jwt.accessToken}',
      },
      body: image.imageBytes,
    );
  }

  static final _imagePicker = ImagePicker();
}
