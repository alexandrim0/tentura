import 'package:flutter/material.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

import '../bloc/my_field_cubit.dart';
import '../widget/beacon_tile.dart';

class MyFieldScreen extends StatelessWidget {
  const MyFieldScreen({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
        minimum: paddingMediumH,
        child: BlocConsumer<MyFieldCubit, MyFieldState>(
          listenWhen: (p, c) => c.hasError,
          listener: (context, state) {
            showSnackBar(
              context,
              isError: true,
              text: state.error?.toString(),
            );
          },
          buildWhen: (p, c) => c.hasNoError,
          builder: (context, state) {
            final decoration = BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            );
            return RefreshIndicator.adaptive(
              onRefresh: context.read<MyFieldCubit>().fetch,
              child: ListView.builder(
                itemCount: state.beacons.length,
                itemBuilder: (context, i) => Container(
                  decoration: decoration,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: BeaconTile(beacon: state.beacons[i]),
                ),
              ),
            );
          },
        ),
      );
}
