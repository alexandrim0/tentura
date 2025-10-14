import 'package:jaspr/server.dart';

import 'package:tentura_server/domain/entity/beacon_entity.dart';

import '../styles/shared_view_styles.dart';
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
      styles: const Styles(width: Unit.percent(100)),
    ),
    div(
      classes: 'card-container',
      [
        div(
          classes: 'card-avatar',
          styles: const Styles(
            margin: Spacing.only(top: Unit.pixels(-68)),
          ),
          [
            AvatarComponent(user: beacon.author),
          ],
        ),

        h1(
          styles: const Styles(
            margin: Spacing.only(top: kEdgeInsetsMS),
          ),
          [
            text(beacon.title),
          ],
        ),

        if (beacon.description.isNotEmpty)
          p(
            styles: const Styles(
              margin: Spacing.only(top: kEdgeInsetsMS),
            ),
            [
              text(beacon.description),
            ],
          ),

        if (beacon.coordinates != null)
          p(
            classes: 'secondary-text',
            styles: Styles(
              margin: Spacing.only(
                top: kEdgeInsetsSXS,
                bottom: beacon.startAt != null && beacon.endAt != null
                    ? kEdgeInsetsS
                    : Unit.zero,
              ),
            ),
            [
              text(beacon.coordinates.toString()),
            ],
          ),

        if (beacon.startAt != null || beacon.endAt != null)
          p(
            classes: 'secondary-text',
            styles: Styles(
              margin: Spacing.only(
                top: beacon.coordinates != null ? Unit.zero : kEdgeInsetsSXS,
              ),
            ),
            [
              text('${beacon.startAt} - ${beacon.endAt}'),
            ],
          ),
      ],
    ),
  ]);
}
