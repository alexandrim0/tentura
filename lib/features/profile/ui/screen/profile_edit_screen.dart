import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/app/router/root_router.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/avatar_image.dart';
import 'package:tentura/ui/widget/gradient_stack.dart';
import 'package:tentura/ui/widget/avatar_positioned.dart';

import '../bloc/profile_cubit.dart';

@RoutePage()
class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  final _profileCubit = GetIt.I<ProfileCubit>();

  bool _hasAvatar = false;

  String _title = '';

  String _description = '';

  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _hasAvatar = _profileCubit.state.profile.hasAvatar;
    _description = _profileCubit.state.profile.description;
    _title = _profileCubit.state.profile.title;
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profileCubit.state.profile;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Save Button
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton.outlined(
              icon: const Icon(Icons.save),
              onPressed: _onSavePressed,
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          // Header
          GradientStack(
            children: [
              // Avatar
              AvatarPositioned(
                child: _imageBytes == null
                    ? AvatarImage(
                        size: AvatarPositioned.childSize,
                        userId: _hasAvatar ? profile.imageId : '',
                      )
                    : Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.memory(
                          _imageBytes!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),

              // Upload\Remove Picture Button
              Positioned(
                top: 225,
                left: 200,
                child: _hasAvatar
                    ? IconButton.filledTonal(
                        iconSize: 50,
                        icon: const Icon(Icons.highlight_remove_outlined),
                        onPressed: () {
                          setState(() {
                            _hasAvatar = false;
                            _imageBytes = null;
                          });
                        },
                      )
                    : IconButton.filledTonal(
                        iconSize: 50,
                        icon: const Icon(Icons.add_a_photo_outlined),
                        onPressed: () async {
                          final image = await pickImage();
                          if (image == null) return;
                          setState(() {
                            _hasAvatar = true;
                            _imageBytes = image.bytes;
                          });
                        },
                      ),
              ),
            ],
          ),

          // Username
          Padding(
            padding: kPaddingAll,
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFormField(
                initialValue: _profileCubit.state.profile.title,
                maxLength: kTitleMaxLength,
                style: textTheme.headlineLarge,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Please, fill Title',
                ),
                onChanged: (value) => _title = value,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                validator: (value) {
                  if (value == null || value.length < kTitleMinLength) {
                    return 'Have to be at least 3 char long!';
                  }
                  return null;
                },
              ),
            ),
          ),

          // User Description
          Expanded(
            child: Padding(
              padding: kPaddingH,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final textStyle = textTheme.bodyMedium!;
                  final painter = TextPainter(
                    text: TextSpan(text: 'A', style: textStyle),
                    maxLines: 1,
                    textDirection: TextDirection.ltr,
                  )..layout();

                  final lineHeight = painter.height;
                  final maxLines = constraints.maxHeight > 0
                      ? (constraints.maxHeight / lineHeight).floor()
                      : 1;

                  return TextFormField(
                    minLines: 1,
                    maxLines: maxLines,
                    style: textStyle,
                    maxLength: kDescriptionLength,
                    initialValue: _profileCubit.state.profile.description,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: textTheme.bodyMedium,
                    ),
                    onChanged: (value) => _description = value,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  );
                },
              ),
            ),
          ),

          const Padding(padding: kPaddingT),
        ],
      ),
    );
  }

  Future<void> _onSavePressed() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      if (_imageBytes != null) {
        await _profileCubit.putAvatarImage(_imageBytes!);
        await AvatarImage.evictFromCache(_profileCubit.state.profile.id);
      }
      await _profileCubit.update(_profileCubit.state.profile.copyWith(
        description: _description,
        hasAvatar: _hasAvatar,
        title: _title,
      ));
      if (mounted) {
        if (await context.maybePop()) return;
        if (mounted) await context.pushRoute(const ProfileMineRoute());
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(
          context,
          isError: true,
          text: e.toString(),
        );
      }
    }
  }
}
