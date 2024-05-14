import 'package:tentura/consts.dart';
import 'package:tentura/ui/routes.dart';
import 'package:tentura/ui/utils/ui_consts.dart';
import 'package:tentura/ui/utils/ferry_utils.dart';
import 'package:tentura/ui/widget/error_center_text.dart';
import 'package:tentura/ui/dialog/share_code_dialog.dart';

import 'package:tentura/features/beacon/ui/widget/beacon_tile.dart';
import 'package:tentura/features/image/ui/widget/avatar_image.dart';

import '../../data/user_utils.dart';
import '../../data/gql/_g/profile_fetch_by_user_id.req.gql.dart';
import '../widget/profile_popup_menu_button.dart';
import '../widget/avatar_positioned.dart';
import '../widget/gradient_stack.dart';

class ProfileViewScreen extends StatelessWidget {
  static GoRoute getRoute({GlobalKey<NavigatorState>? parentNavigatorKey}) =>
      GoRoute(
        path: pathProfileView,
        parentNavigatorKey: parentNavigatorKey,
        builder: (context, state) => const ProfileViewScreen(),
      );

  const ProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = GoRouterState.of(context).uri.queryParameters['id'] ?? '';
    void request(GProfileFetchByUserIdReqBuilder b) => b.vars.user_id = userId;
    return Operation(
      client: GetIt.I<Client>(),
      operationRequest: GProfileFetchByUserIdReq(request),
      builder: (context, response, error) {
        final profile = response?.data?.user_by_pk;
        final textTheme = Theme.of(context).textTheme;
        final beacons = response?.data?.user_by_pk?.beacons
                .where((e) => e.enabled)
                .toList(growable: false) ??
            [];
        return Scaffold(
          body: showLoaderOrErrorOr(response, error) ??
              RefreshIndicator.adaptive(
                onRefresh: () async => GetIt.I<Client>().requestController.add(
                      GProfileFetchByUserIdReq(request),
                    ),
                child: profile == null
                    ? const ErrorCenterText(error: 'Profile not found!')
                    : CustomScrollView(
                        slivers: [
                          // Header
                          SliverAppBar(
                            actions: [
                              // Graph View
                              IconButton(
                                icon: const Icon(Icons.hub_outlined),
                                onPressed: () => context.push(Uri(
                                  path: pathGraph,
                                  queryParameters: {'focus': userId},
                                ).toString()),
                              ),
                              // Share
                              IconButton(
                                icon: const Icon(Icons.share_outlined),
                                onPressed: () => ShareCodeDialog.show(
                                  context,
                                  id: userId,
                                  link: Uri.https(
                                    appLinkBase,
                                    pathHomeProfile,
                                    {'id': userId},
                                  ).toString(),
                                ),
                              ),
                              // More
                              ProfilePopupMenuButton(
                                user: profile,
                                isMine: false,
                              ),
                            ],
                            floating: true,
                            expandedHeight: GradientStack.defaultHeight,
                            flexibleSpace: FlexibleSpaceBar(
                              background: GradientStack(
                                children: [
                                  AvatarPositioned(
                                    child: AvatarImage(
                                      userId: profile.imageId,
                                      size: AvatarPositioned.childSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Body
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: paddingH20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title
                                  Text(
                                    profile.title.isEmpty
                                        ? 'No name'
                                        : profile.title,
                                    textAlign: TextAlign.left,
                                    style: textTheme.headlineLarge,
                                  ),
                                  const Padding(padding: paddingV8),
                                  // Description
                                  Text(
                                    profile.description,
                                    textAlign: TextAlign.left,
                                    style: textTheme.bodyLarge,
                                  ),
                                  const Divider(),
                                  Text(
                                    'Beacons',
                                    textAlign: TextAlign.left,
                                    style: textTheme.titleMedium,
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                          ),
                          // Beacons
                          if (beacons.isNotEmpty)
                            SliverList.separated(
                              itemCount: beacons.length,
                              itemBuilder: (context, i) => Padding(
                                padding: paddingH20,
                                child: BeaconTile(
                                  beacon: beacons[i],
                                ),
                              ),
                              separatorBuilder: (_, __) => const Divider(
                                indent: 20,
                                endIndent: 20,
                              ),
                            ),
                        ],
                      ),
              ),
        );
      },
    );
  }
}
