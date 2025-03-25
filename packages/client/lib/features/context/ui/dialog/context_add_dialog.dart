import 'package:flutter/material.dart';
import 'package:tentura_root/i10n/I10n.dart';

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
        title: Text(I10n.of(context)!.addNewTopic),
        content: TextField(
          controller: _controller,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
            child: Text(I10n.of(context)!.buttonOk),
          ),
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text(I10n.of(context)!.buttonCancel),
          ),
        ],
      );
}
