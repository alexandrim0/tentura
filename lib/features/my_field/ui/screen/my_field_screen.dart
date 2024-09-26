import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

import 'package:tentura/features/auth/ui/bloc/auth_cubit.dart';
import 'package:tentura/features/beacon/ui/widget/beacon_tile.dart';
import 'package:tentura/features/context/ui/widget/context_drop_down.dart';

import '../bloc/my_field_cubit.dart';

@RoutePage()
class MyFieldScreen extends StatelessWidget implements AutoRouteWrapper {
  const MyFieldScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocSelector<AuthCubit, AuthState, String>(
        bloc: GetIt.I<AuthCubit>(),
        selector: (state) => state.currentAccountId,
        builder: (context, accountId) => BlocProvider(
          create: (_) => MyFieldCubit(),
          child: this,
        ),
      );

  @override
  Widget build(BuildContext context) => SafeArea(
        minimum: const EdgeInsets.only(
          left: kSpacingMedium,
          right: kSpacingMedium,
          top: kSpacingMedium,
        ),
        child: Column(
          children: [
            // Context selector
            ContextDropDown(
              onChanged: context.read<MyFieldCubit>().fetch,
            ),

            // Beacons list
            Expanded(
              child: BlocConsumer<MyFieldCubit, MyFieldState>(
                listenWhen: (p, c) => c.hasError,
                listener: showSnackBarError,
                buildWhen: (p, c) => c.hasNoError,
                builder: (context, state) {
                  return ListView.separated(
                    itemCount: state.beacons.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, i) {
                      final beacon = state.beacons[i];
                      return Padding(
                        padding: kPaddingV,
                        child: BeaconTile(
                          beacon: beacon,
                          key: ValueKey(beacon),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
}
