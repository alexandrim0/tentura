import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:tentura/consts.dart';

import 'package:tentura/features/auth/ui/bloc/auth_cubit.dart';
import 'package:tentura_root/i10n/I10n.dart';

import 'package:tentura/ui/bloc/screen_cubit.dart';
import 'package:tentura/ui/widget/linear_pi_active.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import '../bloc/beacon_cubit.dart';
import '../widget/beacon_tile.dart';

@RoutePage()
class BeaconScreen extends StatefulWidget implements AutoRouteWrapper {
  const BeaconScreen({@queryParam this.id = '', super.key});

  final String id;

  @override
  Widget wrappedRoute(_) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => ScreenCubit()),
      BlocProvider(
        create: (_) {
          return BeaconCubit(
            profileId: id,
            isMine: GetIt.I<AuthCubit>().checkIfIsMe(id),
          );
        },
      ),
    ],
    child: MultiBlocListener(
      listeners: const [
        BlocListener<BeaconCubit, BeaconState>(
          listener: commonScreenBlocListener,
        ),
        BlocListener<ScreenCubit, ScreenState>(
          listener: commonScreenBlocListener,
        ),
      ],
      child: this,
    ),
  );

  @override
  State<BeaconScreen> createState() => _BeaconScreenState();
}

class _BeaconScreenState extends State<BeaconScreen> {
  final _scrollController = ScrollController();

  late final _cubit = context.read<BeaconCubit>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.hasClients &&
          _scrollController.offset >
              _scrollController.position.maxScrollExtent * kFetchListOffset) {
        _cubit.fetch();
      }
    });
    _cubit.fetch();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: LinearPiActive.size,
          child: BlocSelector<BeaconCubit, BeaconState, bool>(
            selector: (state) => state.isLoading,
            builder: LinearPiActive.builder,
            bloc: _cubit,
          ),
        ),
        title: Text(I10n.of(context)!.beaconsTitle),
      ),
      body: BlocBuilder<BeaconCubit, BeaconState>(
        bloc: _cubit,
        buildWhen: (_, c) => c.isSuccess,
        builder: (_, state) {
          return state.beacons.isEmpty
              ? Center(
                child: Text(
                  I10n.of(context)!.noBeaconsMessage,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
              : ListView.separated(
                key: ValueKey(state.beacons),
                controller: _scrollController,
                itemCount: state.beacons.length,
                itemBuilder: (_, i) {
                  final beacon = state.beacons[i];
                  return Padding(
                    padding: kPaddingAll,
                    child: BeaconTile(
                      key: ValueKey(beacon),
                      isMine: state.isMine,
                      beacon: beacon,
                    ),
                  );
                },
                separatorBuilder: separatorBuilder,
              );
        },
      ),
    );
  }
}
