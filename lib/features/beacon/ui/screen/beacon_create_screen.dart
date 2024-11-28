import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/domain/entity/coordinates.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';

import 'package:tentura/features/geo/ui/dialog/choose_location_dialog.dart';
import 'package:tentura/features/context/ui/widget/context_drop_down.dart';
import 'package:tentura/features/context/ui/bloc/context_cubit.dart';

import '../bloc/beacon_cubit.dart';
import '../dialog/beacon_publish_dialog.dart';

@RoutePage()
class BeaconCreateScreen extends StatefulWidget implements AutoRouteWrapper {
  const BeaconCreateScreen({super.key});

  @override
  State<BeaconCreateScreen> createState() => _BeaconCreateScreenState();

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
        create: (_) => ContextCubit(),
        child: this,
      );
}

class _BeaconCreateScreenState extends State<BeaconCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _imageController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateRangeController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTimeRange? _dateRange;
  Coordinates? _coordinates;
  Uint8List? _image;

  @override
  void dispose() {
    _titleController.dispose();
    _imageController.dispose();
    _locationController.dispose();
    _dateRangeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [
            // Publish Button
            Padding(
              padding: kPaddingH,
              child: TextButton(
                onPressed: _onPublish,
                child: const Text('Publish'),
              ),
            ),
          ],
        ),

        // Input Form
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: ListView(
            padding: kPaddingAll,
            children: [
              // Title
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Beacon title (required)',
                ),
                keyboardType: TextInputType.text,
                maxLength: kTitleMaxLength,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                validator: _titleValidator,
              ),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Description',
                ),
                keyboardType: TextInputType.multiline,
                maxLength: kDescriptionLength,
                maxLines: null,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
              ),

              // Context
              const Padding(
                padding: kPaddingSmallV,
                child: ContextDropDown(key: Key('BeaconContextSelector')),
              ),

              // Location
              Padding(
                padding: kPaddingSmallV,
                child: TextFormField(
                  readOnly: true,
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: 'Add location',
                    suffixIcon: _locationController.text.isEmpty
                        ? const Icon(TenturaIcons.location)
                        : IconButton(
                            icon: const Icon(Icons.cancel_rounded),
                            onPressed: _onClearLocation,
                          ),
                  ),
                  onTap: _onPickLocation,
                ),
              ),

              // Date Range
              Padding(
                padding: kPaddingSmallV,
                child: TextFormField(
                  readOnly: true,
                  controller: _dateRangeController,
                  decoration: InputDecoration(
                    hintText: 'Set display period',
                    suffixIcon: _dateRangeController.text.isEmpty
                        ? const Icon(TenturaIcons.calendar)
                        : IconButton(
                            icon: const Icon(Icons.cancel_rounded),
                            onPressed: _onClearDate,
                          ),
                  ),
                  onTap: _onPickDate,
                ),
              ),

              // Image
              Padding(
                padding: kPaddingSmallV,
                child: TextFormField(
                  readOnly: true,
                  controller: _imageController,
                  decoration: InputDecoration(
                    hintText: 'Attach image',
                    suffixIcon: _image == null
                        ? const Icon(Icons.add_a_photo_rounded)
                        : IconButton(
                            icon: const Icon(Icons.cancel_rounded),
                            onPressed: _onImageClear,
                          ),
                  ),
                  onTap: _onPickImage,
                ),
              ),

              // Image Container
              Padding(
                padding: const EdgeInsets.all(48),
                child: GestureDetector(
                  onTap: _onPickImage,
                  child: _image == null
                      ? DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                          ),
                          child: const Icon(
                            Icons.photo_outlined,
                            size: 256,
                          ),
                        )
                      : Image.memory(
                          _image!,
                          key: ObjectKey(_image),
                          fit: BoxFit.fitWidth,
                        ),
                ),
              ),
            ],
          ),
        ),
      );

  Future<void> _onPickLocation() async {
    final location = await ChooseLocationDialog.show(
      context,
      center: _coordinates,
    );
    if (location == null) return;
    _locationController.text =
        location.place?.toString() ?? _coordinates.toString();
    setState(() => _coordinates = location.coords);
  }

  void _onClearLocation() {
    _locationController.clear();
    setState(() => _coordinates = null);
  }

  Future<void> _onPickDate() async {
    final now = DateTime.timestamp();
    final dateRange = await showDateRangePicker(
      context: context,
      firstDate: now,
      currentDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      saveText: 'Ok',
    );
    if (dateRange == null) return;
    _dateRangeController.text =
        '${fYMD(dateRange.start)} - ${fYMD(dateRange.end)}';
    setState(() => _dateRange = dateRange);
  }

  void _onClearDate() {
    _dateRangeController.clear();
    setState(() => _dateRange = null);
  }

  Future<void> _onPickImage() async {
    final newImage = await pickImage();
    if (newImage == null) return;
    _imageController.text = newImage.name;
    setState(() => _image = newImage.bytes);
  }

  void _onImageClear() {
    _imageController.clear();
    setState(() => _image = null);
  }

  String? _titleValidator(String? title) {
    if (title == null || title.length < kTitleMinLength) {
      return 'Title too short';
    }
    return null;
  }

  Future<void> _onPublish() async {
    if (_formKey.currentState?.validate() ?? false) {
      final contextName = context.read<ContextCubit>().state.selected;
      if (await BeaconPublishDialog.show(context) ?? false) {
        try {
          await GetIt.I<BeaconCubit>().create(
            beacon: emptyBeacon.copyWith(
              title: _titleController.text,
              description: _descriptionController.text,
              coordinates: _coordinates,
              dateRange: _dateRange,
              context: contextName,
            ),
            image: _image,
          );
          if (mounted) await context.maybePop();
        } catch (e) {
          if (mounted) {
            showSnackBar(
              context,
              isError: true,
              text: e.toString(),
            );
          }
        }
      }
    }
  }
}
