import 'package:jaspr/server.dart';

import 'package:tentura_server/domain/entity/beacon_entity.dart';

import '../styles/shared_view_styles.dart';
import 'avatar_component.dart';

class BeaconViewComponent extends StatelessComponent {
  const BeaconViewComponent({required this.beacon});

  final BeaconEntity beacon;

  @override
  Iterable<Component> build(BuildContext context) => [
    img(
      src: beacon.imageUrl,
      styles: const Styles(width: Unit.percent(100)),
    ),
    div([
      div(
        [AvatarComponent(user: beacon.author)],
        classes: 'card-avatar',
        styles: const Styles(
          margin: Spacing.only(top: Unit.pixels(-68)),
        ),
      ),
      h1([
        text(beacon.title),
      ], styles: const Styles(margin: Spacing.only(top: kEdgeInsetsMS))),
      if (beacon.description.isNotEmpty)
        p(
          [text(beacon.description)],
          styles: const Styles(margin: Spacing.only(top: kEdgeInsetsMS)),
        ),
      if (beacon.coordinates != null)
        p(
          [text(beacon.coordinates.toString())],
          classes: 'secondary-text',
          styles: Styles(
            margin: Spacing.only(
              top: kEdgeInsetsSXS,
              bottom: beacon.startAt != null && beacon.endAt != null
                  ? kEdgeInsetsS
                  : Unit.zero,
            ),
          ),
        ),
      if (beacon.startAt != null || beacon.endAt != null)
        p(
          [text('${beacon.startAt} - ${beacon.endAt}')],
          classes: 'secondary-text',
          styles: Styles(
            margin: Spacing.only(
              top: beacon.coordinates != null ? Unit.zero : kEdgeInsetsSXS,
            ),
          ),
        ),
    ], classes: 'card-container'),
  ];
}
