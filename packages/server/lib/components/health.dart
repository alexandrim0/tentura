import 'package:jaspr/server.dart';

class HealthComponent extends StatelessComponent {
  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield p(
      [
        text('I`m fine!'),
      ],
    );
  }
}
