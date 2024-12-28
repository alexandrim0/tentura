import 'package:flutter/material.dart';

import 'package:tentura/app/router/root_router.dart';
import 'package:tentura/domain/entity/comment.dart';
import 'package:tentura/ui/widget/avatar_rated.dart';
import 'package:tentura/ui/widget/rating_indicator.dart';
import 'package:tentura/ui/widget/share_code_icon_button.dart';
import 'package:tentura/ui/widget/show_more_text.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import 'package:tentura/features/like/ui/widget/like_control.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    required this.comment,
    this.isMine = false,
    super.key,
  });

  final Comment comment;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),

        Padding(
          key: const Key('CommentHeader'),
          padding: kPaddingSmallT,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              GestureDetector(
                onTap: () =>
                    context.pushRoute(ProfileViewRoute(id: comment.author.id)),
                child: Padding(
                  padding: const EdgeInsets.only(right: kSpacingMedium),
                  child: AvatarRated(profile: comment.author),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    GestureDetector(
                      onTap: () => context
                          .pushRoute(ProfileViewRoute(id: comment.author.id)),
                      child: Text(
                        isMine ? 'Me' : comment.author.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),

                    // Body
                    Padding(
                      padding: kPaddingSmallT,
                      child: ShowMoreText(
                        comment.content,
                        style: ShowMoreText.buildTextStyle(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Buttons
        Padding(
          key: const Key('CommentButtons'),
          padding: kPaddingSmallV,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Share
              ShareCodeIconButton.id(comment.id),

              // Rating bar
              if (!isMine)
                RatingIndicator(
                  key: ValueKey(comment.score),
                  score: comment.score,
                ),

              // Vote
              if (!isMine)
                LikeControl(
                  entity: comment,
                  key: ValueKey(comment),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
