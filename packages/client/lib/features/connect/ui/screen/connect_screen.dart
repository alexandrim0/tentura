import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tentura_root/i10n/I10n.dart';

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

  late final _i10n = I10n.of(context)!;

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
              child: Text(_i10n.writeCodeHere, textAlign: TextAlign.center),
            ),

            // Input
            Padding(
              padding: kPaddingT,
              child: TextFormField(
                controller: _inputController,
                contextMenuBuilder:
                    (_, EditableTextState state) =>
                        AdaptiveTextSelectionToolbar.buttonItems(
                          anchors: state.contextMenuAnchors,
                          buttonItems: [
                            ContextMenuButtonItem(
                              onPressed: _getCodeFromClipboard,
                              type: ContextMenuButtonType.paste,
                            ),
                          ],
                        ),
                decoration: const InputDecoration(filled: true),
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                textAlign: TextAlign.center,
                maxLength: kIdLength,
              ),
            ),

            // Button (search)
            Padding(
              padding: kPaddingV,
              child: FilledButton(
                child: Text(_i10n.buttonSearch),
                onPressed: () => _goWithCode(_inputController.text),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: kSpacingSmall),
              child: Text(_i10n.labelOr, textAlign: TextAlign.center),
            ),

            // Button (paste)
            Padding(
              padding: kPaddingV,
              child: FilledButton(
                onPressed: _getCodeFromClipboard,
                child: Text(_i10n.buttonPaste),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: kSpacingSmall),
              child: Text(_i10n.labelOr, textAlign: TextAlign.center),
            ),

            // Button (scan qr)
            Padding(
              padding: kPaddingV,
              child: FilledButton(
                onPressed: () async {
                  final code = await QRScanDialog.show(context);
                  if (context.mounted) _goWithCode(code);
                },
                child: Text(_i10n.buttonScanQR),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Future<void> _getCodeFromClipboard() async {
    final text = (await Clipboard.getData(Clipboard.kTextPlain))?.text;
    if (text == null) return;
    if (text.length == kIdLength) {
      _inputController.text = text;
    } else {
      try {
        final id = Uri.dataFromString(text).queryParameters['id'];
        if (id != null) {
          _inputController.text = id;
        }
      } catch (_) {}
    }
  }

  void _goWithCode(String? code) {
    if (code == null || code.isEmpty) return;
    if (code.length != kIdLength) {
      showSnackBar(context, isError: true, text: _i10n.codeLengthError);
    }
    switch (code[0]) {
      case 'U':
        context.pushRoute(ProfileViewRoute(id: code));

      case 'B':
        context.pushRoute(BeaconViewRoute(id: code));

      case 'C':
        context.pushRoute(BeaconViewRoute(id: code));

      default:
        showSnackBar(context, isError: true, text: _i10n.codePrefixError);
    }
  }
}
