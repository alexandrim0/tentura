import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/opinion.dart';
import 'package:tentura/ui/bloc/screen_cubit.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/avatar_rated.dart';
import 'package:tentura/ui/widget/share_code_icon_button.dart';
import 'package:tentura/ui/widget/show_more_text.dart';

import '../bloc/opinion_cubit.dart';
import '../dialog/opinion_delete_dialog.dart';

class OpinionTile extends StatelessWidget {
  const OpinionTile({required this.opinion, this.isMine = false, super.key});

  final Opinion opinion;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            GestureDetector(
              onTap:
                  isMine
                      ? null
                      : () => context.read<ScreenCubit>().showProfile(
                        opinion.author.id,
                      ),
              child: Padding(
                padding: const EdgeInsets.only(right: kSpacingMedium),
                child: AvatarRated.small(
                  profile: opinion.author,
                  withRating: !isMine,
                ),
              ),
            ),

            // Body
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    isMine ? 'Me' : opinion.author.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  // Opinion
                  Padding(
                    padding: kPaddingSmallT,
                    child: ShowMoreText(
                      opinion.content,
                      style: ShowMoreText.buildTextStyle(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Footer (Buttons)
        Row(
          children: [
            // Share
            ShareCodeIconButton.id(opinion.id),

            const Spacer(),

            if (isMine)
              // More
              PopupMenuButton(
                itemBuilder:
                    (context) => [
                      PopupMenuItem<void>(
                        onTap: () async {
                          if (await OpinionDeleteDialog.show(context) ??
                              false) {
                            if (context.mounted) {
                              await context
                                  .read<OpinionCubit>()
                                  .removeOpinionById(opinion.id);
                            }
                          }
                        },
                        child: const Text('Delete my opinion'),
                      ),
                    ],
              ),
          ],
        ),
      ],
    );
  }
}
