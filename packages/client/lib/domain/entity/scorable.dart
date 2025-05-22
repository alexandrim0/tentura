import 'identifiable.dart';

abstract class Scorable extends Identifiable {
  double get score;

  double get reverseScore;
}
