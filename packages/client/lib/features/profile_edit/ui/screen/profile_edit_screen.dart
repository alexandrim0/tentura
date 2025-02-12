import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/entity/image_entity.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/avatar_rated.dart';
import 'package:tentura/ui/widget/deep_back_button.dart';
import 'package:tentura/ui/widget/gradient_stack.dart';
import 'package:tentura/ui/widget/avatar_positioned.dart';

import 'package:tentura/features/profile/ui/bloc/profile_cubit.dart';

import '../bloc/profile_edit_cubit.dart';

@RoutePage()
class ProfileEditScreen extends StatelessWidget implements AutoRouteWrapper {
  const ProfileEditScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ProfileEditCubit(
              profile: GetIt.I<ProfileCubit>().state.profile,
            ),
          ),
        ],
        child: MultiBlocListener(
          listeners: const [
            BlocListener<ProfileEditCubit, ProfileEditState>(
              listener: commonScreenBlocListener,
            ),
          ],
          child: this,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cubit = context.read<ProfileEditCubit>();
    return Scaffold(
      // Header
      appBar: AppBar(
        actions: [
          // Save Button
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: kPaddingAll,
              child: IconButton.outlined(
                icon: const Icon(
                  Icons.save,
                  color: Colors.black,
                ),
                onPressed: cubit.save,
              ),
            ),
          ),
        ],

        // Back Button
        leading: const Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: kPaddingAll,
            child: DeepBackButton(
              color: Colors.black,
            ),
          ),
        ),
        toolbarHeight: GradientStack.defaultHeight,

        // Avatar
        flexibleSpace:
            BlocSelector<ProfileEditCubit, ProfileEditState, ImageEntity?>(
          selector: (state) => state.image,
          builder: (context, image) => FlexibleSpaceBar(
            background: GradientStack(
              children: [
                AvatarPositioned(
                  child: image == null
                      // Original Avatar
                      ? AvatarRated(
                          profile: cubit.profile,
                          size: AvatarPositioned.childSize,
                          withRating: false,
                        )
                      : SizedBox.square(
                          dimension: AvatarPositioned.childSize,
                          child: ClipOval(
                            child: image.imageBytes.isEmpty
                                // Placeholder
                                ? Image.asset(
                                    kAssetAvatarPlaceholder,
                                    // ignore: avoid_redundant_argument_values //
                                    package: kAssetPackage,
                                  )
                                // New Avatar
                                : Image.memory(
                                    image.imageBytes,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                ),
                Positioned(
                  top: _top,
                  left: _left,
                  child: image == null || image.imageBytes.isNotEmpty
                      // Remove Picture Button
                      ? IconButton.filledTonal(
                          iconSize: 50,
                          icon: const Icon(
                            Icons.highlight_remove_outlined,
                          ),
                          onPressed: cubit.clearImage,
                        )
                      // Upload Picture Button
                      : IconButton.filledTonal(
                          iconSize: 50,
                          icon: const Icon(
                            Icons.add_a_photo_outlined,
                          ),
                          onPressed: cubit.pickImage,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,

      // Form
      body: Column(
        children: [
          // Username
          Padding(
            padding: kPaddingAll,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUnfocus,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Please, fill Title',
              ),
              initialValue: cubit.state.title,
              maxLength: kTitleMaxLength,
              style: textTheme.headlineLarge,
              onChanged: cubit.setTitle,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              validator: cubit.titleValidator,
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
                    text: TextSpan(
                      text: 'A',
                      style: textStyle,
                    ),
                    maxLines: 1,
                    textDirection: TextDirection.ltr,
                  )..layout();
                  return TextFormField(
                    maxLines: constraints.maxHeight > 0
                        ? (constraints.maxHeight / painter.height).floor()
                        : 1,
                    minLines: 1,
                    maxLength: kDescriptionLength,
                    keyboardType: TextInputType.multiline,
                    initialValue: cubit.state.description,
                    autovalidateMode: AutovalidateMode.onUnfocus,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: textTheme.bodyMedium,
                    ),
                    style: textStyle,
                    onChanged: cubit.setDescription,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    validator: cubit.descriptionValidator,
                  );
                },
              ),
            ),
          ),

          const Padding(
            padding: kPaddingT,
          ),
        ],
      ),
    );
  }

  static const _top = 225.0;
  static const _left = 200.0;
}
