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
  Iterable<Component> build(BuildContext context) => [
        img(
          src: beacon.imageUrl,
          styles: const Styles.box(
            width: Unit.percent(100),
          ),
        ),
        div(
          [
            div(
              [
                AvatarComponent(user: beacon.author),
              ],
              classes: 'card-avatar',
              styles: const Styles.box(
                margin: EdgeInsets.only(
                  top: Unit.pixels(-68),
                ),
              ),
            ),
            h1(
              [
                text(beacon.title),
              ],
              styles: const Styles.box(
                margin: EdgeInsets.only(
                  top: kEdgeInsetsMS,
                ),
              ),
            ),
            if (beacon.description.isNotEmpty)
              p(
                [
                  text(beacon.description),
                ],
                styles: const Styles.box(
                  margin: EdgeInsets.only(
                    top: kEdgeInsetsMS,
                  ),
                ),
              ),
            if (beacon.coordinates != null)
              p(
                [
                  text(beacon.coordinates.toString()),
                ],
                classes: 'secondary-text',
                styles: Styles.box(
                  margin: EdgeInsets.only(
                    top: kEdgeInsetsSXS,
                    bottom: beacon.timerange != null ? kEdgeInsetsS : Unit.zero,
                  ),
                ),
              ),
            if (beacon.timerange != null)
              p(
                [
                  text(beacon.timerange.toString()),
                ],
                classes: 'secondary-text',
                styles: Styles.box(
                  margin: EdgeInsets.only(
                    top:
                        beacon.coordinates != null ? Unit.zero : kEdgeInsetsSXS,
                  ),
                ),
              ),
          ],
          classes: 'card-container',
        ),
      ];
}
