import 'package:jaspr/server.dart';

import 'package:tentura_server/view/components/shared_view_component.dart';

Future<Response> sharedViewController(Request request) async => Response.ok(
      await renderComponent(
        Document(
          body: SharedViewComponent(),
        ),
      ),
      headers: {'Content-Type': 'text/html'},
    );
