import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:tentura/features/auth/ui/bloc/auth_cubit.dart';
import 'package:tentura/features/beacon/ui/widget/beacon_tile.dart';
import 'package:tentura/features/context/ui/bloc/context_cubit.dart';
import 'package:tentura/features/context/ui/widget/context_drop_down.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

import '../bloc/my_field_cubit.dart';

@RoutePage()
class MyFieldScreen extends StatelessWidget implements AutoRouteWrapper {
  const MyFieldScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocSelector<AuthCubit, AuthState, String>(
        bloc: GetIt.I<AuthCubit>(),
        selector: (state) => state.currentAccountId,
        builder: (_, accountId) {
          final contextCubit = GetIt.I<ContextCubit>();
          return MultiBlocProvider(
            key: ValueKey(accountId),
            providers: [
              BlocProvider.value(value: contextCubit),
              BlocProvider(
                create: (_) => MyFieldCubit(
                  initialContext: contextCubit.state.selected,
                ),
              ),
            ],
            child: MultiBlocListener(
              listeners: [
                BlocListener<ContextCubit, ContextState>(
                  bloc: contextCubit,
                  listenWhen: (p, c) => p.selected != c.selected,
                  listener: (context, state) =>
                      context.read<MyFieldCubit>().fetch(state.selected),
                ),
                const BlocListener<MyFieldCubit, MyFieldState>(
                  listener: commonScreenBlocListener,
                ),
              ],
              child: this,
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    final myFieldCubit = context.read<MyFieldCubit>();
    return SafeArea(
      minimum: kPaddingSmallH,
      child: Column(
        children: [
          // Context selector
          const ContextDropDown(
            key: Key('MyFieldContextSelector'),
          ),

          // Beacons list
          Expanded(
            child: BlocBuilder<MyFieldCubit, MyFieldState>(
              bloc: myFieldCubit,
              buildWhen: (_, c) => c.isSuccess || c.isLoading,
              builder: (_, state) => state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : RefreshIndicator.adaptive(
                      onRefresh: myFieldCubit.fetch,
                      child: ListView.builder(
                        itemCount: state.beacons.length,
                        itemBuilder: (_, i) {
                          final beacon = state.beacons[i];
                          return Padding(
                            padding: kPaddingSmallV,
                            child: BeaconTile(
                              key: ValueKey(beacon),
                              beacon: beacon,
                              isMine: false,
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
