import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:tentura/env.dart';
import 'package:tentura/ui/bloc/screen_cubit.dart';
import 'package:tentura/ui/l10n/l10n.dart';
import 'package:tentura/ui/utils/string_input_validator.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/linear_pi_active.dart';

import '../bloc/auth_cubit.dart';

@RoutePage()
class AuthRegisterScreen extends StatefulWidget implements AutoRouteWrapper {
  const AuthRegisterScreen({
    @PathParam('id') this.id = '',
    @QueryParam(kQueryIsDeepLink) this.isDeepLink,
    super.key,
  });

  final String id;

  final String? isDeepLink;

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
    final invitationId = widget.id.trim();
    if (invitationId.isNotEmpty) {
      _codeController.text = invitationId;
    } else {
      unawaited(
        _authCubit.getCodeFromClipboard().then((code) {
          if (code.isNotEmpty) {
            setState(() {
              _codeController.text = code;
            });
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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: Text(_l10n.createNewAccount),
      leading: const AutoLeadingButton(),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
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

          // Register
          Padding(
            padding: kPaddingAll,
            child: FilledButton(
              onPressed: () => GetIt.I<AuthCubit>().signUp(
                invitationCode: _codeController.text,
                title: _titleController.text,
              ),
              child: Text(_l10n.buttonCreate),
            ),
          ),
        ],
      ),
    ),
  );

  Future<void> _getCodeFromClipboard() async {
    final code = await _authCubit.getCodeFromClipboard();
    if (code.isNotEmpty) {
      _codeController.text = code;
    }
  }
}
