import '../services/offline_storage_service.dart';

class UserProfile {
  final String name;
  final String arabicName;
  final DateTime birthDate;
  final String gender;
  final String mizac;

  const UserProfile({
    required this.name,
    required this.arabicName,
    required this.birthDate,
    required this.gender,
    required this.mizac,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'arabic_name': arabicName,
        'birth_date': birthDate.toIso8601String(),
        'gender': gender,
        'mizac': mizac,
      };

  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
        name: map['name'] as String? ?? '',
        arabicName: map['arabic_name'] as String? ?? '',
        birthDate: DateTime.tryParse(map['birth_date'] as String? ?? '') ??
            DateTime(1990, 1, 1),
        gender: map['gender'] as String? ?? 'belirtilmedi',
        mizac: map['mizac'] as String? ?? '',
      );

  static UserProfile? load() {
    final data = OfflineStorageService.getSetting('user_profile');
    if (data == null) return null;
    try {
      return UserProfile.fromMap(Map<String, dynamic>.from(data as Map));
    } catch (_) {
      return null;
    }
  }

  Future<void> save() async {
    await OfflineStorageService.saveSetting('user_profile', toMap());
  }

  int get lifePathNumber {
    final digits =
        birthDate.toIso8601String().substring(0, 10).replaceAll('-', '');
    return _reduce(digits.split('').map(int.parse).reduce((a, b) => a + b));
  }

  int _reduce(int n) {
    while (n > 9 && n != 11 && n != 22 && n != 33) {
      n = n.toString().split('').map(int.parse).reduce((a, b) => a + b);
    }
    return n;
  }
}
