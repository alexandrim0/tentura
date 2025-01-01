import 'package:jaspr/server.dart';

import '../components/shared_view_component.dart';

Future<Response> sharedViewController(Request request) async => Response.ok(
      await renderComponent(
        Document(
          body: SharedViewComponent(),
        ),
      ),
      headers: {'Content-Type': 'text/html'},
    );
