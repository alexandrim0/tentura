import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:tentura/ui/widget/deep_back_button.dart';
import 'package:tentura/ui/widget/linear_pi_active.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import 'package:tentura/features/context/ui/bloc/context_cubit.dart';
import 'package:tentura/features/context/ui/widget/context_drop_down.dart';

import '../bloc/beacon_create_cubit.dart';
import '../widget/date_range_input.dart';
import '../widget/description_input.dart';
import '../widget/image_box.dart';
import '../widget/image_input.dart';
import '../widget/location_input.dart';
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
          BlocProvider(
            create: (_) => ContextCubit(),
          ),
          BlocProvider(
            create: (_) => BeaconCreateCubit(),
          ),
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
  final _imageController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateRangeController = TextEditingController();

  @override
  void dispose() {
    _imageController.dispose();
    _locationController.dispose();
    _dateRangeController.dispose();
    super.dispose();
  }

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
              selector: (state) => state.isLoading,
              builder: LinearPiActive.builder,
            ),
          ),
          leading: const DeepBackButton(),
          centerTitle: true,
          title: const Text(
            'Create new Beacon',
          ),
        ),

        // Input Form
        body: Form(
          key: _formKey,
          child: ListView(
            padding: kPaddingAll,
            children: [
              // Title
              const TitleInput(),

              // Description
              const DescriptionInput(),

              // Context
              const Padding(
                padding: kPaddingSmallV,
                child: ContextDropDown(),
              ),

              // Location
              Padding(
                padding: kPaddingSmallV,
                child: LocationInput(
                  controller: _locationController,
                ),
              ),

              // Date Range
              Padding(
                padding: kPaddingSmallV,
                child: DateRangeInput(
                  controller: _dateRangeController,
                ),
              ),

              // Image Control
              Padding(
                padding: kPaddingSmallV,
                child: ImageInput(
                  controller: _imageController,
                ),
              ),

              // Image Container
              const Padding(
                padding: EdgeInsets.all(48),
                child: ImageBox(),
              ),
            ],
          ),
        ),
      );
}
