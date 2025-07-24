import 'package:injectable/injectable.dart';

import '../service/firebase_service.dart';

@injectable
class FcmRepository {
  FcmRepository(this._firebaseService);

  final FirebaseService _firebaseService;
}
