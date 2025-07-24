import 'package:injectable/injectable.dart';

import '../service/firebase_service.dart';

@injectable
class FcmRepository {
  FcmRepository(this._firebaseService);

  // ignore: unused_field // TBD:
  final FirebaseService _firebaseService;
}
