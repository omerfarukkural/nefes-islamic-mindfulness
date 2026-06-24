import 'package:flutter_test/flutter_test.dart';
import 'package:nefes_app/features/mizac/domain/mizac_calculator.dart';
import 'package:nefes_app/features/mizac/domain/mizac_model.dart';

void main() {
  group('MizacCalculator', () {
    group('fromBirthSeason', () {
      test('spring (March) → dem', () {
        final result = MizacCalculator.fromBirthSeason(DateTime(1990, 3, 15));
        expect(result, MizacType.dem);
      });

      test('spring (April) → dem', () {
        final result = MizacCalculator.fromBirthSeason(DateTime(1990, 4, 1));
        expect(result, MizacType.dem);
      });

      test('spring (May) → dem', () {
        final result = MizacCalculator.fromBirthSeason(DateTime(1990, 5, 31));
        expect(result, MizacType.dem);
      });

      test('summer (June) → safra', () {
        final result = MizacCalculator.fromBirthSeason(DateTime(1990, 6, 1));
        expect(result, MizacType.safra);
      });

      test('summer (August) → safra', () {
        final result = MizacCalculator.fromBirthSeason(DateTime(1990, 8, 15));
        expect(result, MizacType.safra);
      });

      test('autumn (September) → sevda', () {
        final result = MizacCalculator.fromBirthSeason(DateTime(1990, 9, 1));
        expect(result, MizacType.sevda);
      });

      test('autumn (November) → sevda', () {
        final result = MizacCalculator.fromBirthSeason(DateTime(1990, 11, 30));
        expect(result, MizacType.sevda);
      });

      test('winter (December) → balgam', () {
        final result = MizacCalculator.fromBirthSeason(DateTime(1990, 12, 25));
        expect(result, MizacType.balgam);
      });

      test('winter (January) → balgam', () {
        final result = MizacCalculator.fromBirthSeason(DateTime(1990, 1, 10));
        expect(result, MizacType.balgam);
      });

      test('winter (February) → balgam', () {
        final result = MizacCalculator.fromBirthSeason(DateTime(1990, 2, 28));
        expect(result, MizacType.balgam);
      });
    });

    group('fromQuestionnaireAnswers', () {
      test('all zeros (first answer each) returns a valid MizacType', () {
        final answers = List.filled(10, 0);
        final result = MizacCalculator.fromQuestionnaireAnswers(answers);
        expect(MizacType.values, contains(result));
      });

      test('returns valid MizacType for any valid input', () {
        final allThrees = List.filled(10, 3);
        final result = MizacCalculator.fromQuestionnaireAnswers(allThrees);
        expect(MizacType.values, contains(result));
      });
    });
  });

  group('MizacTypeExt', () {
    test('all types have non-empty labels', () {
      for (final type in MizacType.values) {
        expect(type.label, isNotEmpty);
      }
    });

    test('all types have valid colors', () {
      for (final type in MizacType.values) {
        // Color.value is the ARGB int — a valid color has non-zero alpha
        expect(type.color.alpha, equals(255));
      }
    });

    test('all types have emoji', () {
      for (final type in MizacType.values) {
        expect(type.emoji, isNotEmpty);
      }
    });

    test('fromName round-trips correctly', () {
      for (final type in MizacType.values) {
        final name = type.name;
        final recovered = MizacTypeExt.fromName(name);
        expect(recovered, type);
      }
    });
  });
}
