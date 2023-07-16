import 'package:flutter/material.dart';

import 'package:gravity/ui/widget/avatar_image.dart';
import 'package:gravity/ui/widget/beacon_image.dart';

import 'package:gravity/data/gql/beacon/_g/_fragments.data.gql.dart';

class BeaconTile extends StatelessWidget {
  final GbeaconFields beacon;

  const BeaconTile({
    required this.beacon,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar
          AvatarImage(
            size: 40,
            userId: beacon.author.has_picture ? beacon.author.id : '',
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // User displayName
                    Text(
                      beacon.author.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      beacon.created_at.toString(),
                    ),
                    const Spacer(),
                    // Menu
                    PopupMenuButton(
                      itemBuilder: (context) => const [
                        PopupMenuItem<void>(child: Text('Share the code')),
                        PopupMenuItem<void>(child: Text('Graph view')),
                      ],
                    ),
                  ],
                ),
                // Beacon Image
                Container(
                  width: 300,
                  height: 200,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: BeaconImage(
                    authorId: beacon.author.id,
                    beaconId: beacon.has_picture ? beacon.id : '',
                  ),
                ),
                // Beacon Title
                Text(
                  beacon.title,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                // Beacon Description
                Text(
                  beacon.description,
                  maxLines: 3,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                // Bottom Buttons Block
                Row(
                  children: [
                    // Like\Dislike
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.thumb_up_outlined),
                            onPressed: () {},
                          ),
                          const Text('10'),
                          IconButton(
                            icon: const Icon(Icons.thumb_down_outlined),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Reply
                    FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.comment_outlined),
                      label: const Text('4'),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.percent_outlined),
                      label: const Text('90%'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      );
}