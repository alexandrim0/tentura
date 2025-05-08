import 'package:flutter/material.dart';

import 'package:tentura/ui/l10n/l10n.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/ui/utils/string_input_validator.dart';
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

  late final _l10n = L10n.of(context)!;

  late final _textTheme = Theme.of(context).textTheme;

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog.adaptive(
    title: Text(_l10n.createNewAccount, style: _textTheme.headlineMedium),
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
                hintText: _l10n.pleaseEnterCode,
                labelText: _l10n.labelInvitationCode,
              ),
              maxLength: kTitleMaxLength,
              style: _textTheme.headlineLarge,
              validator: (text) => invitationCodeValidator(_l10n, text),
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
              hintText: _l10n.pleaseFillTitle,
              labelText: _l10n.labelTitle,
            ),
            maxLength: kTitleMaxLength,
            style: _textTheme.headlineLarge,
            validator: (text) => titleValidator(_l10n, text),
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
        child: Text(_l10n.buttonCreate),
      ),
      TextButton(
        onPressed: Navigator.of(context).pop,
        child: Text(_l10n.buttonCancel),
      ),
    ],
  );
}
