import 'package:flutter/material.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/use_case/string_input_validator.dart';
import 'package:localization/localization.dart';
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
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  late final _textTheme = Theme.of(context).textTheme;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog.adaptive(
    title: Text(AppLocalizations.of(context)!.createNewAccount, style: _textTheme.headlineMedium),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Username
        Padding(
          padding: kPaddingAll,
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUnfocus,
            controller: _titleController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.labelTitle,
              hintText: AppLocalizations.of(context)!.pleaseFillTitle,
            ),
            maxLength: kTitleMaxLength,
            style: _textTheme.headlineLarge,
            validator: titleValidator,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
          ),
        ),

        // User Description
        Padding(
          padding: kPaddingAll,
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUnfocus,
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.labelDescription,
              labelStyle: _textTheme.bodyMedium,
            ),
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            minLines: 1,
            style: _textTheme.bodyMedium,
            validator: descriptionValidator,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
          ),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () async {
          await GetIt.I<AuthCubit>().signUp(
            description: _descriptionController.text,
            title: _titleController.text,
          );
          if (context.mounted) Navigator.of(context).pop();
        },
        child: Text(AppLocalizations.of(context)!.buttonCreate),
      ),
      TextButton(
        onPressed: Navigator.of(context).pop,
        child: Text(AppLocalizations.of(context)!.buttonCancel),
      ),
    ],
  );
}
