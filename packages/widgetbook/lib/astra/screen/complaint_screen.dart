import 'package:flutter/material.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/deep_back_button.dart';
import 'package:tentura_widgetbook/astra/widget/theme_astra.dart';

import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'Default',
  type: ComplaintScreen,
  path: '[astra]/screen/complaint_dialog',
)
Widget settingsUseCase(BuildContext context) => const ComplaintScreen();

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final _detailsController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedComplaintType;
  final _complaintTypes = ['Violates CSAE Policy', 'Violates Platform Rules'];

  @override
  void initState() {
    super.initState();
    _selectedComplaintType = _complaintTypes.first;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      //TODO: to change to the real validation
      const success = true;
      await _showResultDialog(success);
    }
  }

  Future<void> _showResultDialog(bool success) async {
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(success ? 'Success!' : 'Error'),
            content: Text(
              success
                  ? 'Complaint submitted successfully!'
                  : 'Something went wrong. Please try again.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (success) Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeAstra(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Submit Complaint'),
          leading: const DeepBackButton(),
        ),
        body: Padding(
          padding: kPaddingAll,
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedComplaintType,
                  items:
                      _complaintTypes
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                  onChanged:
                      (value) => setState(() => _selectedComplaintType = value),
                  decoration: const InputDecoration(
                    labelText: 'Complaint Type',
                    border: OutlineInputBorder(),                  
                  ),
                  dropdownColor: Theme.of(context).colorScheme.secondaryContainer,
                  validator:
                      (value) =>
                          value == null
                              ? 'Please select a complaint type'
                              : null,
                ),
                const Padding(padding: kPaddingSmallV),
                TextFormField(
                  controller: _detailsController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Details*',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator:
                      (value) =>
                          value?.isEmpty ?? true
                              ? 'Please provide details'
                              : null,
                ),
                const Padding(padding: kPaddingSmallV),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email for feedback (optional)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return null;
                    return RegExp(
                          r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$',
                        ).hasMatch(value!)
                        ? null
                        : 'Please enter a valid email';
                  },
                ),
                const Padding(padding: kPaddingV),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(padding: kPaddingV),
                  child: const Text('SUBMIT COMPLAINT'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _detailsController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
