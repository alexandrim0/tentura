sealed class FavoritesException implements Exception {
  const FavoritesException([this.message]);

  final String? message;
}

final class FavoritesPinException extends FavoritesException {
  const FavoritesPinException([super.message]);
}

final class FavoritesUnpinException extends FavoritesException {
  const FavoritesUnpinException([super.message]);
}
