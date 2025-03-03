import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/ui/bloc/state_base.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import '../../domain/enum.dart';
import 'complaint_state.dart';

export 'complaint_state.dart';

class ComplaintCubit extends Cubit<ComplaintState> {
  ComplaintCubit({required String id}) : super(ComplaintState(id: id));

  void setType(ComplaintType? type) {
    if (type == null) return;

    emit(state.copyWith(type: type));
  }

  void setDetails(String value) => emit(state.copyWith(details: value));

  void setEmail(String value) => emit(state.copyWith(email: value));

  Future<void> submit() async {
    final now = DateTime.now();
    await launchUrlString(
      Mailto(
        to: [kComplaintEmail],
        subject: 'Complaint',
        body:
            '-----\n'
            'Date: ${dateFormatYMD(now)}  ${timeFormatHm(now)}\n'
            'Link: $kServerName$kPathAppLinkView?id:${state.id}\n'
            'E-mail: ${state.email}'
            '-----\n'
            '${state.details}',
      ).toString(),
    );
  }
}
