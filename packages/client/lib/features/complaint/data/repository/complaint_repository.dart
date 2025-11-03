import 'package:injectable/injectable.dart';

import 'package:tentura_root/domain/enums.dart';

import 'package:tentura/data/service/remote_api_service.dart';

import '../gql/_g/complaint_create.req.gql.dart';

@lazySingleton
class ComplaintRepository {
  ComplaintRepository(this._remoteApiService);

  final RemoteApiService _remoteApiService;

  Future<bool> create({
    required String id,
    required String email,
    required String details,
    required ComplaintType type,
  }) => _remoteApiService
      .request(
        GCreateComplaintReq(
          (b) => b.vars
            ..id = id
            ..email = email
            ..details = details
            ..type = type.name,
        ),
      )
      .firstWhere((e) => e.dataSource == DataSource.Link)
      .then((r) => r.dataOrThrow(label: _label).complaintCreate);

  static const _label = 'Complaint';
}
