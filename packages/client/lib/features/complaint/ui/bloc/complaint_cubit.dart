import 'package:get_it/get_it.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:tentura_root/domain/enums.dart';

import 'package:tentura/env.dart';
import 'package:tentura/ui/bloc/state_base.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import 'complaint_state.dart';

export 'complaint_state.dart';

class ComplaintCubit extends Cubit<ComplaintState> {
  ComplaintCubit({required String id}) : super(ComplaintState(id: id));

  final _env = GetIt.I<Env>();

  ///
  void setType(ComplaintType? type) {
    if (type != null) {
      emit(state.copyWith(type: type));
    }
  }

  ///
  void setDetails(String value) => emit(state.copyWith(details: value));

  ///
  void setEmail(String value) => emit(state.copyWith(email: value));

  ///
  Future<void> submit() async {
    final now = DateTime.now();
    await launchUrlString(
      Mailto(
        to: [_env.complaintEmail],
        subject: 'Complaint',
        body:
            '-----\n'
            'Date: ${dateFormatYMD(now)}  ${timeFormatHm(now)}\n'
            'Link: ${_env.serverUrlBase}${_env.pathAppLinkView}?id:${state.id}\n'
            'E-mail: ${state.email}'
            '-----\n'
            '${state.details}',
      ).toString(),
    );
  }
}
