import 'package:jaspr/server.dart';

import 'package:tentura_server/domain/entity/beacon_entity.dart';
import 'package:tentura_server/utils/format_date.dart';

import 'avatar_component.dart';

class BeaconViewComponent extends StatelessComponent {
  const BeaconViewComponent({
    required this.beacon,
  });

  final BeaconEntity beacon;

  @override
  Component build(BuildContext context) => fragment([
    img(
      src: beacon.imageUrl,
      alt: 'beacon image',
    ),
    section(
      styles: const Styles(
        margin: Spacing.only(top: Unit.pixels(-68)),
      ),
      [
        // Avatar
        AvatarComponent(user: beacon.author),

        // Title
        h4(
          [
            text(beacon.title),
          ],
        ),

        if (beacon.description.isNotEmpty)
          p(
            [
              text(beacon.description),
            ],
          ),

        if (beacon.coordinates != null)
          small(
            [
              text(beacon.coordinates.toString()),
              br(),
            ],
          ),

        if (beacon.startAt != null)
          small(
            [
              text('from ${formatDate(beacon.startAt)}'),
              if (beacon.endAt != null) text(', '),
            ],
          ),

        if (beacon.endAt != null)
          small(
            [
              text('until ${formatDate(beacon.endAt)}'),
            ],
          ),
      ],
    ),
  ]);
}
