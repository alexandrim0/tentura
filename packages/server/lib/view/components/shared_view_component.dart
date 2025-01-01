import 'package:jaspr/server.dart';

class SharedViewComponent extends StatelessComponent {
  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield p(
      [
        text('I`m fine!'),
      ],
    );
  }
}
