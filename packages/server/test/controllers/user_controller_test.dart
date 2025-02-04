// ignore_for_file: avoid_print //

import 'dart:io';
import 'package:test/test.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'package:tentura_server/di/di.dart';
import 'package:tentura_server/consts.dart';
import 'package:tentura_server/api/controllers/user/user_image_upload.dart';
import 'package:tentura_server/api/controllers/user/user_login_controller.dart';
import 'package:tentura_server/api/controllers/user/user_register_controller.dart';
import 'package:tentura_server/data/repository/user_repository_mock.dart';
import 'package:tentura_server/domain/enum.dart';
import 'package:tentura_server/utils/jwt.dart';

import '../consts.dart';
import '../data.dart';
import '../utils/jwt_test.dart';

Future<void> main() async {
  final authRequestToken = issueAuthRequestToken(publicKey);
  final authHeader = {
    kHeaderAuthorization: 'Bearer $authRequestToken',
  };

  setUp(() {
    configureDependencies(
      kIsIntegrationTest ? Environment.dev : Environment.test,
    );
    UserRepositoryMock.storageByPublicKey.addAll(kUserByPublicKey);
  });

  tearDown(() async {
    await getIt.reset();
  });

  test(
    'routeUserRegister',
    () async {
      final response = await getIt<UserRegisterController>().handler(
        Request(
          'POST',
          Uri.http(
            kLocalhost,
            kPathRegister,
          ),
          headers: authHeader,
        ),
      );
      final responseBody = await response.readAsString();
      print(responseBody);

      expect(responseBody, isNotEmpty);
    },
  );

  test(
    'routeUserLogin',
    () async {
      final response = await getIt<UserLoginController>().handler(
        Request(
          'POST',
          Uri.http(
            kLocalhost,
            kPathLogin,
          ),
          headers: authHeader,
        ),
      );
      final responseBody = await response.readAsString();
      print(responseBody);

      expect(responseBody, isNotEmpty);
    },
  );

  test(
    'routeUserLogin, with static request',
    () async {
      final response = await getIt<UserLoginController>().handler(
        Request(
          'POST',
          Uri.http(
            kLocalhost,
            kPathLogin,
          ),
          headers: {
            kHeaderAuthorization:
                'Bearer eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCJ9.eyJwayI6IjFVTUJueGd4ZVJCTDQwMzcyMTlfMzVDUHZSYlBtc1AyUVUxUlVSeXRpaHciLCJleHAiOjE3MzcyMTU2MTcsImlhdCI6MTczNzIxMjAxN30.A4rU-BoK-mtswY1aSCeWpldHlySGok_DR_sUDAHvOeemQPvDQ6mYCuFG1bb5A-fP7dYGdvyh0-wnIkLDQdgFCg',
          },
        ),
      );
      final responseBody = await response.readAsString();
      print(responseBody);

      expect(responseBody, isNotEmpty);
    },
  );

  test(
    'routeUserImageUpload',
    () async {
      final user = kUserByPublicKey[kPussyCatKey]!;
      final response = await getIt<UserImageUploadController>().handler(
        Request(
          'PUT',
          Uri.http(
            kLocalhost,
            kPathImageUpload,
            {
              'id': user.id,
            },
          ),
          headers: {
            ...authHeader,
            kHeaderContentType: kContentTypeJpeg,
          },
          context: {
            kContextUserId: user.id,
          },
          body: await File('../client/images/placeholder/avatar.jpg')
              .readAsBytes(),
        ),
      );
      final responseBody = await response.readAsString();

      expect(
        response.statusCode,
        200,
        reason: responseBody,
      );

      expect(
        UserRepositoryMock.storageByPublicKey[kPussyCatKey]!.blurHash,
        '|QPjJjoL?bxu~qRjD%xut7M{j[%MayIUj[t7j[ay~qa{xuWBD%of%MWBayRjj[j[ayxuj[M{ayof?bj[ITWBayofayWBM{xuayRjofofWBWBj[kCRjj[t7ayRjayRjofxus:fQfQfRWBj[ofayayWBf7offQWBj[ofWBof',
        reason: responseBody,
      );
    },
  );
}
