import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:tentura/env.dart';
import 'package:tentura/ui/bloc/screen_cubit.dart';
import 'package:tentura/ui/l10n/l10n.dart';
import 'package:tentura/ui/utils/string_input_validator.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/deep_back_button.dart';
import 'package:tentura/ui/widget/linear_pi_active.dart';

import '../bloc/auth_cubit.dart';

@RoutePage()
class AuthRegisterScreen extends StatefulWidget implements AutoRouteWrapper {
  const AuthRegisterScreen({
    @queryParam this.id,
    super.key,
  });

  final String? id;

  @override
  State<AuthRegisterScreen> createState() => _AuthRegisterScreenState();

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
    create: (_) => ScreenCubit(),
    child: MultiBlocListener(
      listeners: [
        const BlocListener<ScreenCubit, ScreenState>(
          listener: commonScreenBlocListener,
        ),
        BlocListener<AuthCubit, AuthState>(
          bloc: GetIt.I<AuthCubit>(),
          listener: commonScreenBlocListener,
        ),
      ],
      child: this,
    ),
  );
}

class _AuthRegisterScreenState extends State<AuthRegisterScreen>
    with StringInputValidator {
  final _env = GetIt.I<Env>();

  final _authCubit = GetIt.I<AuthCubit>();

  final _codeController = TextEditingController();

  final _titleController = TextEditingController();

  late final _textTheme = Theme.of(context).textTheme;

  late final _l10n = L10n.of(context)!;

  @override
  void initState() {
    super.initState();
    if (widget.id != null && widget.id!.isNotEmpty) {
      if (kDebugMode) {
        print('Query param Id: ${widget.id}');
      }
      _codeController.text = widget.id!;
    } else {
      unawaited(
        _authCubit.getCodeFromClipboard().then((code) {
          if (code.isNotEmpty) {
            _codeController.text = code;
          }
        }),
      );
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_l10n.createNewAccount),
        leading: const DeepBackButton(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: BlocSelector<AuthCubit, AuthState, bool>(
            key: Key('Loader:${_authCubit.hashCode}'),
            selector: (state) => state.isLoading,
            builder: LinearPiActive.builder,
            bloc: _authCubit,
          ),
        ),
      ),
      body: Form(
        child: Column(
          children: [
            // Invite Code
            if (_env.needInviteCode)
              Padding(
                padding: kPaddingAll,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  controller: _codeController,
                  contextMenuBuilder: (_, state) =>
                      AdaptiveTextSelectionToolbar.buttonItems(
                        anchors: state.contextMenuAnchors,
                        buttonItems: [
                          ContextMenuButtonItem(
                            type: ContextMenuButtonType.paste,
                            onPressed: _getCodeFromClipboard,
                          ),
                        ],
                      ),

                  decoration: InputDecoration(
                    hintText: _l10n.pleaseEnterCode,
                    labelText: _l10n.labelInvitationCode,
                    suffix: IconButton(
                      onPressed: _getCodeFromClipboard,
                      icon: const Icon(Icons.paste_rounded),
                    ),
                  ),
                  maxLength: kIdLength,
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

            const Spacer(),

            // Create new account
            Padding(
              padding:
                  kPaddingAll +
                  const EdgeInsets.only(bottom: 60 - kSpacingMedium),
              child: Row(
                children: [
                  // Register
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        await GetIt.I<AuthCubit>().signUp(
                          invitationCode: _codeController.text,
                          title: _titleController.text,
                        );
                      },
                      child: Text(_l10n.buttonCreate),
                    ),
                  ),

                  const Padding(padding: EdgeInsets.only(left: kSpacingMedium)),

                  // Cancel
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: context.read<ScreenCubit>().back,
                      child: Text(_l10n.buttonCancel),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getCodeFromClipboard() async {
    final code = await _authCubit.getCodeFromClipboard();
    if (code.isNotEmpty) {
      _codeController.text = code;
    }
  }
}
