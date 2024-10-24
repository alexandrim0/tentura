import 'package:gql_error_link/gql_error_link.dart';

ErrorLink buildErrorLink() => ErrorLink(
      onException: (request, forward, exception) {
        // ignore: avoid_print
        print(exception);
        return null;
      },
      onGraphQLError: (request, forward, response) {
        // ignore: avoid_print
        print(response.errors);
        return null;
      },
    );
