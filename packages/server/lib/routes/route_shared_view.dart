import 'package:jaspr/server.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../components/health.dart';

Future<Response> routeSharedView(Request request) async => Response.ok(
      await renderComponent(
        Document(
          body: HealthComponent(),
        ),
      ),
      headers: {'Content-Type': 'text/html'},
    );

// ignore: unused_element // example
void _() {
  Router()

    // binding to a different path than '/' only works because we set the
    // base: '/app' parameter on the document
    ..mount(
      '/app',
      serveApp(
        (request, render) {
          // Optionally do something with `request`
          // Return a server-rendered response by calling `render()`
          // with your root component
          return render(
            Document(
              base: '/app',
              body: HealthComponent(),
            ),
          );
        },
      ),
    )
    ..get(
      '/hello',
      (request) async {
        // Render a single component manually
        return Response.ok(
          await renderComponent(
            Document(
              // we still point to /app to correctly load all other resources,
              // like js, css or image files
              base: '/app',
              body: HealthComponent(),
            ),
          ),
          headers: {'Content-Type': 'text/html'},
        );
      },
    );
}
