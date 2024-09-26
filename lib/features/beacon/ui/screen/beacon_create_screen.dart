import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/entity/geo.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/dialog/choose_location_dialog.dart';

import 'package:tentura/features/context/ui/widget/context_drop_down.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';

import '../bloc/beacon_cubit.dart';

@RoutePage()
class BeaconCreateScreen extends StatefulWidget {
  const BeaconCreateScreen({super.key});

  @override
  State<BeaconCreateScreen> createState() => _BeaconCreateScreenState();
}

class _BeaconCreateScreenState extends State<BeaconCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _imageController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateRangeController = TextEditingController();
  final _descriptionController = TextEditingController();

  late final _beaconCubit = context.read<BeaconCubit>();

  DateTimeRange? _dateRange;
  Coordinates? _coordinates;
  Uint8List? _image;
  String? _context;

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
            TextButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  try {
                    await _beaconCubit.create(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      coordinates: _coordinates,
                      dateRange: _dateRange,
                      context: _context,
                      image: _image,
                    );
                    if (context.mounted) await context.maybePop();
                  } catch (e) {
                    if (context.mounted) {
                      showSnackBar(
                        context,
                        isError: true,
                        text: e.toString(),
                      );
                    }
                  }
                } else {
                  showSnackBar(
                    context,
                    isError: true,
                    text: 'Please check input data!',
                  );
                }
              },
              child: const Text('Publish'),
            ),
            const SizedBox(width: 16),
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
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                validator: (value) {
                  if (value == null || value.length < kTitleMinLength) {
                    return 'Title too short';
                  }
                  return null;
                },
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
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
              ),

              // Context
              ContextDropDown(
                onChanged: (value) async => _context = value,
              ),

              // Location
              const SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: 'Add location',
                  suffixIcon: _locationController.text.isEmpty
                      ? const Icon(TenturaIcons.location)
                      : IconButton(
                          onPressed: () {
                            _coordinates = null;
                            _locationController.clear();
                          },
                          icon: const Icon(Icons.cancel_rounded),
                        ),
                ),
                onTap: () async {
                  final location = await ChooseLocationDialog.show(
                    context,
                    center: _coordinates,
                  );
                  if (location != null) {
                    _coordinates = location.coords;
                    _locationController.text = location.place.country == null
                        ? _coordinates.toString()
                        : '${location.place.locality ?? "Unknown"}, '
                            '${location.place.country}';
                  }
                },
              ),
              const Padding(padding: kPaddingSmallV),

              // Time
              TextFormField(
                readOnly: true,
                controller: _dateRangeController,
                decoration: InputDecoration(
                  hintText: 'Set display period',
                  suffixIcon: _dateRangeController.text.isEmpty
                      ? const Icon(TenturaIcons.calendar)
                      : IconButton(
                          onPressed: () {
                            _dateRange = null;
                            _dateRangeController.clear();
                          },
                          icon: const Icon(Icons.cancel_rounded),
                        ),
                ),
                onTap: () async {
                  final now = DateTime.timestamp();
                  final dateRange = await showDateRangePicker(
                    context: context,
                    firstDate: now,
                    lastDate: now.add(const Duration(days: 365)),
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                  );
                  if (dateRange != null) {
                    _dateRange = dateRange;
                    _dateRangeController.text =
                        '${fYMD(_dateRange!.start)} - ${fYMD(_dateRange!.end)}';
                  }
                },
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: kSpacingSmall)),

              // Image Input
              TextFormField(
                readOnly: true,
                controller: _imageController,
                decoration: InputDecoration(
                  hintText: 'Attach image',
                  suffixIcon: _image == null
                      ? const Icon(Icons.add_a_photo_rounded)
                      : IconButton(
                          onPressed: () {
                            _imageController.clear();
                            setState(() => _image = null);
                          },
                          icon: const Icon(Icons.cancel_rounded),
                        ),
                ),
                onTap: () async {
                  final newImage = await _beaconCubit.pickImage();
                  if (newImage != null) {
                    _imageController.text = newImage.name;
                    _image = newImage.bytes;
                    setState(() {});
                  }
                },
              ),

              // Image Container
              Container(
                decoration: BoxDecoration(
                  border:
                      _image == null ? Border.all(color: Colors.black12) : null,
                ),
                margin: const EdgeInsets.symmetric(vertical: 48),
                child: _image == null
                    ? const Icon(
                        Icons.photo_outlined,
                        size: 200,
                      )
                    : Image.memory(
                        _image!,
                        key: ObjectKey(_image),
                        fit: BoxFit.fitWidth,
                      ),
              ),
            ],
          ),
        ),
      );
}
