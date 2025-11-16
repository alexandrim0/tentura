import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

import '../widget/theme_astra.dart';

@UseCase(
  name: 'Default',
  type: ComplaintDialog,
  path: '[astra]/dialog',
)
Widget settingsUseCase(BuildContext context) => const ComplaintDialog();

class ComplaintDialog extends StatefulWidget {
  const ComplaintDialog({super.key});

  @override
  State<ComplaintDialog> createState() => _ComplaintDialogState();
}

class _ComplaintDialogState extends State<ComplaintDialog> {
  final _formKey = GlobalKey<FormState>();
  final _detailsController = TextEditingController();
  final _emailController = TextEditingController();

  String? _selectedComplaintType = _complaintTypes.first;

  @override
  void dispose() {
    _detailsController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ThemeAstra(
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Submit Complaint'),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: kPaddingAll,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                initialValue: _selectedComplaintType,
                items: _complaintTypes
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedComplaintType = value),
                decoration: const InputDecoration(
                  labelText: 'Complaint Type',
                  border: OutlineInputBorder(),
                ),
                dropdownColor: Theme.of(
                  context,
                ).colorScheme.secondaryContainer,
                validator: (value) =>
                    value == null ? 'Please select a complaint type' : null,
              ),
              //
              const Padding(padding: kPaddingSmallV),
              //
              TextFormField(
                controller: _detailsController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Details*',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Please provide details' : null,
              ),
              //
              const Padding(padding: kPaddingSmallV),
              //
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email for feedback (optional)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value?.isEmpty ?? true)
                    ? null
                    : RegExp(
                        r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$',
                      ).hasMatch(value!)
                    ? null
                    : 'Please enter a valid email',
              ),
              //
              const Padding(padding: kPaddingV),
              //
              ElevatedButton(
                onPressed: () =>
                    _showResultDialog(_formKey.currentState!.validate()),
                style: ElevatedButton.styleFrom(padding: kPaddingV),
                child: const Text('SUBMIT COMPLAINT'),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Future<void> _showResultDialog(bool success) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: success ? const Text('Success!') : const Text('Error'),
      content: success
          ? const Text('Complaint submitted successfully!')
          : const Text('Something went wrong. Please try again.'),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('OK'),
        ),
      ],
    ),
  );

  static const _complaintTypes = [
    'Violates CSAE Policy',
    'Violates Platform Rules',
  ];
}
