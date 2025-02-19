import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/opinion.dart';

import 'package:tentura/features/like/ui/widget/like_control.dart';

import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/avatar_rated.dart';
import 'package:tentura/ui/widget/rating_indicator.dart';
import 'package:tentura/ui/widget/share_code_icon_button.dart';
import 'package:tentura/ui/widget/show_more_text.dart';

import '../bloc/opinion_cubit.dart';

class OpinionTile extends StatelessWidget {
  const OpinionTile({required this.opinion, this.isMine = false, super.key});

  final Opinion opinion;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),

        // Header
        Padding(
          key: const Key('OpinionHeader'),
          padding: kPaddingSmallT,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              GestureDetector(
                onTap:
                    isMine
                        ? null
                        : () => context.read<OpinionCubit>().showProfile(
                          opinion.author.id,
                        ),
                child: Padding(
                  padding: const EdgeInsets.only(right: kSpacingMedium),
                  child: AvatarRated(profile: opinion.author),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      isMine ? 'Me' : opinion.author.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),

                    // Body
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
        ),

        // Footer (Buttons)
        Padding(
          key: const Key('OpinionButtons'),
          padding: kPaddingSmallV,
          child: Row(
            children: [
              // Share
              ShareCodeIconButton.id(opinion.id),

              const Spacer(),

              // Rating bar
              if (!isMine) ...[
                Padding(
                  padding: kPaddingH,
                  child: RatingIndicator(
                    key: ValueKey(opinion.score),
                    score: opinion.score,
                  ),
                ),

                // Vote
                LikeControl(entity: opinion, key: ValueKey(opinion)),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
