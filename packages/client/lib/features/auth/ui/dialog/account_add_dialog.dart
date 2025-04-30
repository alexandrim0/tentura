import 'package:flutter/material.dart';
import 'package:tentura/domain/enum.dart';

import 'package:tentura_root/i10n/I10n.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/use_case/string_input_validator.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import '../bloc/auth_cubit.dart';

class AccountAddDialog extends StatefulWidget {
  static Future<void> show(BuildContext context) =>
      showDialog(context: context, builder: (_) => const AccountAddDialog());

  const AccountAddDialog({super.key});

  @override
  State<AccountAddDialog> createState() => _AccountAddDialogState();
}

class _AccountAddDialogState extends State<AccountAddDialog>
    with StringInputValidator {
  final _codeController = TextEditingController();

  final _titleController = TextEditingController();

  late final _i10n = I10n.of(context)!;

  late final _textTheme = Theme.of(context).textTheme;

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog.adaptive(
    title: Text(_i10n.createNewAccount, style: _textTheme.headlineMedium),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Invite Code
        if (kNeedInviteCode)
          Padding(
            padding: kPaddingAll,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUnfocus,
              controller: _codeController,
              decoration: InputDecoration(
                hintText: _i10n.pleaseEnterCode,
                labelText: _i10n.labelInvitationCode,
              ),
              maxLength: kTitleMaxLength,
              style: _textTheme.headlineLarge,
              validator:
                  (String? code) => switch (invitationCodeValidator(code)) {
                    StringInputValidatorErrors.tooShort =>
                      _i10n.invitationCodeTooShort,
                    StringInputValidatorErrors.tooLong =>
                      _i10n.invitationCodeTooLong,
                    StringInputValidatorErrors.wrongFormat =>
                      _i10n.invitationCodeWrongFormat,
                    _ => null,
                  },
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
            ),
          ),

        // Username
        Padding(
          padding: kPaddingAll,
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUnfocus,
            controller: _titleController,
            decoration: InputDecoration(
              hintText: _i10n.pleaseFillTitle,
              labelText: _i10n.labelTitle,
            ),
            maxLength: kTitleMaxLength,
            style: _textTheme.headlineLarge,
            validator: titleValidator,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
          ),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () async {
          await GetIt.I<AuthCubit>().signUp(
            invitationCode: _codeController.text,
            title: _titleController.text,
          );
          if (context.mounted) Navigator.of(context).pop();
        },
        child: Text(_i10n.buttonCreate),
      ),
      TextButton(
        onPressed: Navigator.of(context).pop,
        child: Text(_i10n.buttonCancel),
      ),
    ],
  );
}
