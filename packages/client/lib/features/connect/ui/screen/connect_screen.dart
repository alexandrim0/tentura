import 'package:flutter/material.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/app/router/root_router.dart';
import 'package:localization/localization.dart';
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
                Padding(
                  padding: kPaddingSmallT,
                  child: Text(AppLocalizations.of(context)!.writeCodeHere,
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
                    child: Text(AppLocalizations.of(context)!.buttonSearch),
                    onPressed: () => _goWithCode(_inputController.text),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    AppLocalizations.of(context)!.labelOr,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: kPaddingV,
                  child: FilledButton(
                    onPressed: () async {
                      final code = await QRScanDialog.show(context);
                      if (context.mounted) _goWithCode(code);
                    },
                    child: Text(AppLocalizations.of(context)!.buttonScanQR),
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
        text: AppLocalizations.of(context)!.codeLengthError,
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
          text: AppLocalizations.of(context)!.codePrefixError,
        );
    }
  }
}
