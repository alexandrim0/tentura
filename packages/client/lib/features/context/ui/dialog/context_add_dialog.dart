import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class ContextAddDialog extends StatefulWidget {
  static Future<String?> show(BuildContext context) => showDialog<String>(
        context: context,
        builder: (context) => const ContextAddDialog(),
      );

  const ContextAddDialog({super.key});

  @override
  State<ContextAddDialog> createState() => _ContextAddDialogState();
}

class _ContextAddDialogState extends State<ContextAddDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog.adaptive(
        title: Text(AppLocalizations.of(context)!.addNewTopic),
        content: TextField(
          controller: _controller,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
            child: Text(AppLocalizations.of(context)!.buttonOk),
          ),
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text(AppLocalizations.of(context)!.buttonCancel),
          ),
        ],
      );
}
