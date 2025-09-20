import 'package:injectable/injectable.dart';

import 'package:tentura/features/my_field/ui/bloc/my_field_cubit.dart';

import 'package:tentura_widgetbook/bloc/_data.dart';

@Singleton(as: MyFieldCubit)
class MyFieldCubitMock extends Cubit<MyFieldState> implements MyFieldCubit {
  MyFieldCubitMock()
    : super(
        MyFieldState(
          beacons: [beaconA, beaconB],
        ),
      );

  @override
  Future<void> fetch([String? contextName]) async {}

  @override
  void addTag(String tag) {}

  @override
  void removeTag(String tag) {}

  @override
  void setSelectedTags(Set<String> tags) {}
}
