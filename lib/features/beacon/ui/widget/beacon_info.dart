import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:tentura/app/router/root_router.dart';
import 'package:tentura/features/context/ui/bloc/context_cubit.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/beacon_image.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';
import 'package:tentura/ui/widget/place_name_text.dart';
import 'package:tentura/ui/dialog/choose_location_dialog.dart';
import 'package:tentura/ui/widget/show_more_text.dart';

import '../../domain/entity/beacon.dart';

class BeaconInfo extends StatelessWidget {
  const BeaconInfo({
    required this.beacon,
    this.isTitleLarge = false,
    super.key,
  });

  final Beacon beacon;
  final bool isTitleLarge;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: context.routeData.name == BeaconViewRoute.name
              ? null
              : () => context.pushRoute(BeaconViewRoute(id: beacon.id)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Beacon Image
              if (beacon.hasPicture)
                Padding(
                  padding: kPaddingSmallT,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: BeaconImage(
                      authorId: beacon.author.imageId,
                      beaconId: beacon.imageId,
                    ),
                  ),
                ),

              // Beacon Title
              Padding(
                padding: kPaddingT,
                child: Text(
                  beacon.title,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: isTitleLarge
                      ? textTheme.headlineLarge
                      : textTheme.headlineMedium,
                ),
              ),
            ],
          ),
        ),

        //Beacon Timerange
        if (beacon.dateRange != null)
          Padding(
            padding: const EdgeInsets.only(bottom: kSpacingSmall),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  TenturaIcons.calendar,
                  size: 18,
                ),
                Text(
                  ' ${fYMD(beacon.dateRange?.start)}'
                  ' - ${fYMD(beacon.dateRange?.end)}',
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
        // Beacon Description
        if (beacon.description.isNotEmpty)
          Padding(
            padding: kPaddingSmallT,
            child: ShowMoreText(
              beacon.description,
              style: ShowMoreText.buildTextStyle(context),
            ),
          ),

        // Beacon Geolocation
        if (beacon.context.isNotEmpty || beacon.coordinates != null)
          Padding(
            padding: kPaddingSmallT,
            child: Wrap(
              runSpacing: kSpacingSmall,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceBetween,
              children: [
                // Beacon Geolocation
                if (beacon.coordinates != null)
                  TextButton.icon(
                    icon: const Icon(
                      TenturaIcons.location,
                      size: 18,
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    label: kIsWeb
                        ? const Text('Show on the map')
                        : PlaceNameText(
                            coords: beacon.coordinates!,
                            style: textTheme.bodySmall,
                          ),
                    onPressed: () => ChooseLocationDialog.show(
                      context,
                      center: beacon.coordinates,
                    ),
                  )
                else
                  const Spacer(),
                // Beacon Topic
                if (beacon.context.isNotEmpty)
                  TextButton(
                    style: const ButtonStyle(
                      padding:
                          WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.zero),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: Text(
                      '#${beacon.context} ',
                      style: textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () async {
                      await GetIt.I<ContextCubit>().add(
                        contextName: beacon.context,
                        select: false,
                      );
                      if (context.mounted) {
                        showSnackBar(
                          context,
                          text: 'Topic ${beacon.context} has been added.',
                        );
                      }
                    },
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
