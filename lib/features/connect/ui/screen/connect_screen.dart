import 'package:flutter/material.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/app/router/root_router.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/dialog/qr_scan_dialog.dart';

@RoutePage()
class ConnectScreen extends StatefulWidget {
  const ConnectScreen({super.key});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  final _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          minimum: kPaddingAll,
          child: Padding(
            padding: kPaddingAll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: kPaddingSmallT,
                  child: Text(
                    'If you have the Code, please write it here:',
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: kPaddingT,
                  child: TextFormField(
                    controller: _inputController,
                    decoration: const InputDecoration(
                      filled: true,
                    ),
                    maxLength: kIdLength,
                    textAlign: TextAlign.center,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  ),
                ),
                Padding(
                  padding: kPaddingV,
                  child: FilledButton(
                    child: const Text('Search'),
                    onPressed: () => _goWithCode(_inputController.text),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    'or',
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: kPaddingV,
                  child: FilledButton(
                    child: const Text('Scan QR'),
                    onPressed: () async {
                      final code = await QRScanDialog.show(context);
                      if (context.mounted) _goWithCode(code);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  void _goWithCode(String? code) {
    if (code == null || code.isEmpty) return;
    if (code.length != kIdLength) {
      showSnackBar(
        context,
        isError: true,
        text: 'Wrong code length!',
      );
    }
    switch (code[0]) {
      case 'U':
        context.pushRoute(ProfileViewRoute(id: code));

      case 'B':
        context.pushRoute(BeaconViewRoute(id: code));

      case 'C':
        context.pushRoute(BeaconViewRoute(id: code));

      default:
        showSnackBar(
          context,
          isError: true,
          text: 'Wrong code prefix!',
        );
    }
  }
}
