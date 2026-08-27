import 'dart:math';

class BodyCompositionResult {
  final double bodyFatPercent;
  final String category;

  BodyCompositionResult({required this.bodyFatPercent, required this.category});

  /// U.S. Navy method — male formula
  static BodyCompositionResult calculateMale({
    required double waistCm,
    required double neckCm,
    required double heightCm,
  }) {
    double bf = 495 /
        (1.0324 -
            0.19077 * (log(waistCm - neckCm) / ln10) +
            0.15456 * (log(heightCm) / ln10)) -
        450;
    return BodyCompositionResult(bodyFatPercent: bf, category: _category(bf, true));
  }

  /// U.S. Navy method — female formula (needs hip measurement)
  static BodyCompositionResult calculateFemale({
    required double waistCm,
    required double neckCm,
    required double heightCm,
    required double hipCm,
  }) {
    double bf = 495 /
        (1.29579 -
            0.35004 * (log(waistCm + hipCm - neckCm) / ln10) +
            0.22100 * (log(heightCm) / ln10)) -
        450;
    return BodyCompositionResult(bodyFatPercent: bf, category: _category(bf, false));
  }

  static String _category(double bf, bool isMale) {
    if (isMale) {
      if (bf < 6) return 'Essential Fat';
      if (bf < 14) return 'Athletic';
      if (bf < 18) return 'Fitness';
      if (bf < 25) return 'Average';
      return 'Above Average';
    } else {
      if (bf < 14) return 'Essential Fat';
      if (bf < 21) return 'Athletic';
      if (bf < 25) return 'Fitness';
      if (bf < 32) return 'Average';
      return 'Above Average';
    }
  }
}