String base64Padded(String value) => switch (value.length % 4) {
  2 => '$value==',
  3 => '$value=',
  _ => value,
};
