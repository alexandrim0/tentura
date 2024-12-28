import 'package:logger/logger.dart';
import 'package:gql_error_link/gql_error_link.dart';

ErrorLink buildErrorLink() => ErrorLink(
      onException: (request, forward, exception) {
        _logger.e(exception);
        return null;
      },
      onGraphQLError: (request, forward, response) {
        _logger.e(response.errors);
        return null;
      },
    );

final _logger = Logger();
