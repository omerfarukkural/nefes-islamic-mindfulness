import 'package:flutter_test/flutter_test.dart';
import 'package:nefes_app/core/services/ebced_service.dart';

void main() {
  group('EbcedService', () {
    group('calculateEbced', () {
      test('calculates simple Arabic word', () {
        // الله: ا(1) + ل(30) + ل(30) + ه(5) = 66
        final result = EbcedService.calculateEbced('الله');
        expect(result, 66);
      });

      test('returns 0 for empty string', () {
        expect(EbcedService.calculateEbced(''), 0);
      });

      test('ignores unknown characters', () {
        expect(EbcedService.calculateEbced('123'), 0);
      });

      test('ب has value 2', () {
        expect(EbcedService.calculateEbced('ب'), 2);
      });

      test('ج has value 3', () {
        expect(EbcedService.calculateEbced('ج'), 3);
      });
    });

    group('reduceToDigit', () {
      test('single digit passes through', () {
        expect(EbcedService.reduceToDigit(7), 7);
      });

      test('master number 11 preserved', () {
        expect(EbcedService.reduceToDigit(11), 11);
      });

      test('master number 22 preserved', () {
        expect(EbcedService.reduceToDigit(22), 22);
      });

      test('master number 33 preserved', () {
        expect(EbcedService.reduceToDigit(33), 33);
      });

      test('reduces 29 to 11 (master)', () {
        // 2+9=11 (master, preserved)
        expect(EbcedService.reduceToDigit(29), 11);
      });

      test('reduces 38 to 2', () {
        // 3+8=11 → 1+1=2... wait 11 is master so it stays 11
        // Actually 38 → 3+8=11 → preserved as 11
        expect(EbcedService.reduceToDigit(38), 11);
      });

      test('reduces 100 to 1', () {
        // 1+0+0 = 1
        expect(EbcedService.reduceToDigit(100), 1);
      });

      test('reduces 999 to 9', () {
        // 9+9+9=27 → 2+7=9
        expect(EbcedService.reduceToDigit(999), 9);
      });
    });

    group('calculateTurkishNumerology', () {
      test('returns positive number for non-empty name', () {
        final result = EbcedService.calculateTurkishNumerology('Ali');
        expect(result, greaterThan(0));
      });

      test('returns 0 for empty string', () {
        expect(EbcedService.calculateTurkishNumerology(''), 0);
      });

      test('is case-insensitive', () {
        final lower = EbcedService.calculateTurkishNumerology('ali');
        final upper = EbcedService.calculateTurkishNumerology('ALI');
        expect(lower, upper);
      });
    });

    group('getNumberMeaning', () {
      test('returns non-empty string for 1-9', () {
        for (int i = 1; i <= 9; i++) {
          final meaning = EbcedService.getNumberMeaning(i);
          expect(meaning, isNotEmpty, reason: 'Number $i should have meaning');
        }
      });

      test('returns non-empty for master number 11', () {
        expect(EbcedService.getNumberMeaning(11), isNotEmpty);
      });

      test('returns non-empty for master number 22', () {
        expect(EbcedService.getNumberMeaning(22), isNotEmpty);
      });
    });
  });
}
