import 'package:injectable/injectable.dart';
import 'package:angel3_graphql/angel3_graphql.dart';

import 'package:tentura_server/consts.dart';

import '_base_controller.dart';

@Injectable(order: 3)
final class GraphiqlController extends BaseController {
  const GraphiqlController(super.env);

  @override
  Future<Response> handler(Request request) async {
    try {
      final response = renderGraphiql(
        graphqlEndpoint: kServerName + kPathGraphQLEndpointV2,
      );
      return Response.ok(
        response,
        headers: {
          kHeaderContentType: kContentTypeHtml,
        },
      );
    } catch (e) {
      return Response.badRequest(body: e);
    }
  }
}
