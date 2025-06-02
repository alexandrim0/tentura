import 'dart:io';
import 'package:args/args.dart';

import 'package:tentura_server/app/app.dart';
import 'package:tentura_server/env.dart';

import 'utils/issue_jwt.dart';
import 'utils/calculate_blur_hashes.dart';

const kJwtKeyName = 'jwt';
const kBlurKeyName = 'blur';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    await const App().run(Env());
  } else {
    ArgParser()
      ..addCommand(kBlurKeyName)
      ..addCommand(
        kJwtKeyName,
        ArgParser()..addOption('sub', callback: issueJwt),
      )
      ..parse(args);
    if (args.contains(kBlurKeyName)) {
      await const BlurHashCalculator().calculateBlurHashes();
    }
  }
  exit(0);
}
