import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';

import 'package:tentura/app/router/root_router.dart';
import 'package:tentura/data/database/database.dart';

@RoutePage()
class DriftScreen extends StatelessWidget {
  const DriftScreen({super.key});

  @override
  Widget build(BuildContext context) => DriftDbViewer(GetIt.I<Database>());
}
