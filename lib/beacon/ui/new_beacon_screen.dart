import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:gravity/_shared/consts.dart';
import 'package:gravity/user/bloc/my_profile_cubit.dart';
import 'package:gravity/beacon/bloc/new_beacon_cubit.dart';
import 'package:gravity/_shared/ui/dialog/on_error_dialog.dart';

import 'dialog/on_choose_location_dialog.dart';
import 'widget/beacon_tile.dart';

class NewBeaconScreen extends StatelessWidget {
  static const _padding = SizedBox(height: 20);

  const NewBeaconScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => NewBeaconCubit(),
        child: BlocConsumer<NewBeaconCubit, NewBeaconState>(
          listener: (context, state) {
            switch (state.status) {
              case NewBeaconStatus.done:
                context.pop();
                break;
              case NewBeaconStatus.error:
                OnErrorDialog.show(context, text: state.error.toString());
                break;
              case NewBeaconStatus.initial:
            }
          },
          builder: (context, state) {
            final cubit = context.read<NewBeaconCubit>();
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                actions: [
                  TextButton(
                    onPressed: state.isValid
                        ? context.read<NewBeaconCubit>().save
                        : null,
                    child: const Text('Done'),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              body: ListView(
                key: const Key('NewBeaconListView'),
                padding: const EdgeInsets.all(20),
                children: [
                  // Title
                  TextField(
                    key: const Key('NewBeaconTitle'),
                    decoration: const InputDecoration(
                      hintText: 'Beacon title',
                    ),
                    keyboardType: TextInputType.text,
                    maxLength: titleMaxLength,
                    onChanged: cubit.setTitle,
                  ),
                  // Description
                  TextField(
                    key: const Key('NewBeaconDescription'),
                    decoration: const InputDecoration(
                      hintText: 'Description',
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLength: descriptionLength,
                    maxLines: null,
                    onChanged: cubit.setDescription,
                  ),
                  // Image
                  TextField(
                    key: const Key('NewBeaconImage'),
                    controller: cubit.imageController,
                    decoration: InputDecoration(
                      hintText: 'Attach image',
                      suffixIcon: state.imagePath.isEmpty
                          ? const Icon(Icons.add_a_photo_rounded)
                          : IconButton(
                              onPressed: cubit.clearImage,
                              icon: const Icon(Icons.cancel_rounded),
                            ),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final file = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                        maxHeight: 1024,
                        maxWidth: 2048,
                      );
                      if (file != null) cubit.setImage(file.name, file.path);
                    },
                  ),
                  // Location
                  _padding,
                  TextField(
                    key: const Key('NewBeaconLocation'),
                    controller: cubit.locationController,
                    decoration: InputDecoration(
                      hintText: 'Add location',
                      suffixIcon: state.coordinates == null
                          ? const Icon(Icons.add_location_rounded)
                          : IconButton(
                              onPressed: cubit.clearCoords,
                              icon: const Icon(Icons.cancel_rounded),
                            ),
                    ),
                    readOnly: true,
                    onTap: () async => cubit
                        .setCoords(await OnChooseLocationDialog.show(context)),
                  ),
                  _padding,
                  // Time
                  TextField(
                    key: const Key('NewBeaconTime'),
                    controller: cubit.dateRangeController,
                    decoration: InputDecoration(
                      hintText: 'Set time',
                      suffixIcon: state.dateRange == null
                          ? const Icon(Icons.date_range_rounded)
                          : IconButton(
                              onPressed: cubit.clearDateRange,
                              icon: const Icon(Icons.cancel_rounded),
                            ),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final now = DateTime.now();
                      cubit.setDateRange(await showDateRangePicker(
                        context: context,
                        firstDate: now,
                        lastDate: now.add(const Duration(days: 365)),
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                      ));
                    },
                  ),
                  // Preview
                  const SizedBox(height: 40),
                  BlocBuilder<MyProfileCubit, MyProfileState>(
                    bloc: GetIt.I<MyProfileCubit>(),
                    builder: (context, me) => BeaconTile(
                      userId: me.id,
                      displayName: me.displayName,
                      avatarUrl: me.photoUrl,
                      title: state.title,
                      description: state.description,
                      imagePath: state.imagePath,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
}