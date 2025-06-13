import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:tentura/ui/l10n/l10n.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/deep_back_button.dart';
import 'package:tentura/ui/widget/linear_pi_active.dart';

import 'package:tentura/features/context/ui/bloc/context_cubit.dart';
import 'package:tentura/features/context/ui/widget/context_drop_down.dart';

import '../bloc/beacon_create_cubit.dart';
import '../widget/date_range_input.dart';
import '../widget/description_input.dart';
import '../widget/image_box.dart';
import '../widget/image_input.dart';
import '../widget/location_input.dart';
import '../widget/polling_expansion_tile.dart';
import '../widget/publish_button.dart';
import '../widget/title_input.dart';

@RoutePage()
class BeaconCreateScreen extends StatefulWidget implements AutoRouteWrapper {
  const BeaconCreateScreen({super.key});

  @override
  State<BeaconCreateScreen> createState() => _BeaconCreateScreenState();

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => ContextCubit()),
      BlocProvider(create: (_) => BeaconCreateCubit()),
    ],
    child: MultiBlocListener(
      listeners: const [
        BlocListener<ContextCubit, ContextState>(
          listener: commonScreenBlocListener,
        ),
        BlocListener<BeaconCreateCubit, BeaconCreateState>(
          listener: commonScreenBlocListener,
        ),
      ],
      child: this,
    ),
  );
}

class _BeaconCreateScreenState extends State<BeaconCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  late final _l10n = L10n.of(context)!;
  late final _beaconCreateCubit = context.read<BeaconCreateCubit>();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [
        // Publish Button
        Padding(
          padding: kPaddingH,
          child: PublishButton(
            key: const Key('BeaconCreate.PublishButton'),
            formKey: _formKey,
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4),
        child: BlocSelector<BeaconCreateCubit, BeaconCreateState, bool>(
          key: const Key('BeaconCreate.LoadIndicator'),
          bloc: _beaconCreateCubit,
          selector: (state) => state.isLoading,
          builder: LinearPiActive.builder,
        ),
      ),
      centerTitle: true,
      leading: const DeepBackButton(),
      title: Text(_l10n.createNewBeacon),
    ),

    // Input Form
    body: Form(
      key: _formKey,
      child: ListView(
        padding: kPaddingAll,
        children: const [
          // Title
          TitleInput(key: Key('BeaconCreate.TitleInput')),

          // Description
          DescriptionInput(key: Key('BeaconCreate.DescriptionInput')),

          // Context
          Padding(
            padding: kPaddingSmallV,
            child: ContextDropDown(key: Key('BeaconCreate.ContextDropDown')),
          ),

          // Location
          Padding(
            padding: kPaddingSmallV,
            child: LocationInput(key: Key('BeaconCreate.LocationInput')),
          ),

          // Date Range
          Padding(
            padding: kPaddingSmallV,
            child: DateRangeInput(key: Key('BeaconCreate.DateRangeInput')),
          ),

          // Image Control
          Padding(
            padding: kPaddingSmallV,
            child: ImageInput(key: Key('BeaconCreate.ImageInput')),
          ),

          // Image Container
          Padding(
            padding: EdgeInsets.all(kSpacingLarge * 2),
            child: ImageBox(),
          ),

          // Add Polling
          PollingExpansionTile(key: Key('BeaconCreate.PollingExpansionTile')),
        ],
      ),
    ),
  );
}
