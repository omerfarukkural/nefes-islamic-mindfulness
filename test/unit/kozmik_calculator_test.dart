import 'package:flutter_test/flutter_test.dart';
import 'package:nefes_app/features/pusula/domain/kozmik_calculator.dart';

void main() {
  group('KozmikCalculator', () {
    group('personalYearNumber', () {
      test('returns value in valid range', () {
        final result = KozmikCalculator.personalYearNumber(
          DateTime(1990, 5, 15),
          2024,
        );
        expect(result, greaterThanOrEqualTo(1));
        expect(result, lessThanOrEqualTo(33));
      });

      test('same birth date different years give different results', () {
        final birthDate = DateTime(1990, 5, 15);
        final y2024 = KozmikCalculator.personalYearNumber(birthDate, 2024);
        final y2025 = KozmikCalculator.personalYearNumber(birthDate, 2025);
        expect(y2024, isNot(y2025));
      });
    });

    group('dailyEnergyNumber', () {
      test('returns value between 1 and 9', () {
        final result =
            KozmikCalculator.dailyEnergyNumber(DateTime(2024, 6, 15));
        expect(result, inInclusiveRange(1, 9));
      });

      test('different dates give valid results', () {
        final dates = [
          DateTime(2024, 1, 1),
          DateTime(2024, 6, 15),
          DateTime(2024, 12, 31),
        ];
        for (final date in dates) {
          expect(
            KozmikCalculator.dailyEnergyNumber(date),
            inInclusiveRange(1, 9),
          );
        }
      });
    });

    group('elementOfNumber', () {
      test('returns non-empty string for 1–9', () {
        for (int i = 1; i <= 9; i++) {
          expect(KozmikCalculator.elementOfNumber(i), isNotEmpty);
        }
      });
    });

    group('dailyGuidance', () {
      test('returns non-empty guidance for any day number 1–9', () {
        for (int i = 1; i <= 9; i++) {
          expect(KozmikCalculator.dailyGuidance(i), isNotEmpty);
        }
      });
    });

    group('personalYearGuidance', () {
      test('returns non-empty guidance for years 1–9', () {
        for (int i = 1; i <= 9; i++) {
          expect(KozmikCalculator.personalYearGuidance(i), isNotEmpty);
        }
      });
    });

    group('islamicDayInfo', () {
      test('returns map with required keys', () {
        final info = KozmikCalculator.islamicDayInfo(DateTime(2024, 6, 15));
        expect(info, isNotEmpty);
      });
    });
  });
}
