class Place {
  const Place({
    this.country = '',
    this.locality = '',
  });

  final String country;

  final String locality;

  bool get isEmpty => country.isEmpty && locality.isEmpty;

  bool get isNotEmpty => country.isNotEmpty && locality.isNotEmpty;

  @override
  String toString() => '$country${locality.isEmpty ? '' : ','} $locality';
}
