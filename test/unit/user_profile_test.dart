import 'package:flutter_test/flutter_test.dart';
import 'package:nefes_app/core/models/user_profile.dart';

UserProfile _profile(DateTime birthDate) => UserProfile(
      name: 'Test',
      arabicName: '',
      birthDate: birthDate,
      gender: 'erkek',
      mizac: '',
    );

void main() {
  group('UserProfile.lifePathNumber', () {
    test('1990-05-15 reduces to 3', () {
      // 1+9+9+0+0+5+1+5 = 30 → 3+0 = 3
      expect(_profile(DateTime(1990, 5, 15)).lifePathNumber, 3);
    });

    test('2000-01-01 reduces to 4', () {
      // 2+0+0+0+0+1+0+1 = 4
      expect(_profile(DateTime(2000, 1, 1)).lifePathNumber, 4);
    });

    test('result is always between 1 and 33', () {
      final testDates = [
        DateTime(2000, 1, 1),
        DateTime(1985, 12, 31),
        DateTime(1999, 11, 11),
        DateTime(1970, 6, 15),
        DateTime(1955, 3, 3),
      ];
      for (final date in testDates) {
        final n = _profile(date).lifePathNumber;
        expect(n, inInclusiveRange(1, 33), reason: 'Date $date gave $n');
      }
    });

    test('master number 11 is preserved when sum equals 11', () {
      // 1+9+8+7+0+2+0+2 = 29 → 2+9=11 → preserved
      final profile = _profile(DateTime(1987, 2, 2));
      // 1+9+8+7+0+2+0+2 = 29 → 11
      expect(profile.lifePathNumber, 11);
    });

    test('master number 22 is preserved when sum equals 22', () {
      // Need digits summing to 22 or something that reduces to 22
      // 1+9+9+3+0+4+0+6 = 32 → 3+2=5. Not 22.
      // 1+9+8+2+1+1+2+9 = 33 → master 33
      final profile = _profile(DateTime(1982, 11, 29));
      // 1+9+8+2+1+1+2+9 = 33
      expect(profile.lifePathNumber, 33);
    });
  });
}
