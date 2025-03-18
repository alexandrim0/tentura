import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import 'package:tentura/features/settings/ui/bloc/settings_cubit.dart';

@RoutePage()
class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        minimum: kPaddingAll,
        child: Column(
          children: [
            const Spacer(),

            // Image
            const SvgPicture(
              AssetBytesLoader(
                'images/intro.svg.vec',
                // ignore: avoid_redundant_argument_values //
                packageName: kAssetPackage,
              ),
            ),

            // Title
            Padding(
              padding: kPaddingAll,
              child: Text(
                'Build Your Network with Clarity',
                textAlign: TextAlign.center,
                style: textTheme.displayMedium,
              ),
            ),

            // Text
            Padding(
              padding: kPaddingAll,
              child: Text(
                'Each post reveals the connections you share. '
                'Enjoy complete transparency and mastery over '
                'your relationships',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge,
              ),
            ),

            const Spacer(),

            // Continue Button
            Padding(
              padding: kPaddingV,
              child: FilledButton(
                onPressed:
                    () async => GetIt.I<SettingsCubit>().setIntroEnabled(false),
                child: const Text('Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
