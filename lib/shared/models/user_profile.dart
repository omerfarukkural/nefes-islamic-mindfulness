class UserProfile {
  final String name;
  final String ageGroup;
  final List<String> concerns;
  final List<String> goals;
  final String spirituality;
  final int dailyMinutes;
  final String preferredTime;
  final DateTime completedAt;

  const UserProfile({
    required this.name,
    required this.ageGroup,
    required this.concerns,
    required this.goals,
    required this.spirituality,
    required this.dailyMinutes,
    required this.preferredTime,
    required this.completedAt,
  });

  static const List<String> allConcerns = [
    'Stres',
    'Kaygı',
    'Uyku sorunları',
    'İlişki problemleri',
    'İş/okul baskısı',
    'Yalnızlık',
    'Öfke kontrolü',
    'Odaklanma güçlüğü',
    'Keder & kayıp',
    'Beden imajı',
    'Amaç kaybı',
    'Bağımlılık',
  ];

  static const List<String> allGoals = [
    'Daha sakin olmak',
    'Daha üretken olmak',
    'Daha mutlu olmak',
    'Sağlıklı alışkanlıklar',
    'İlişkilerimi iyileştirmek',
  ];

  static const List<String> spiritualityOptions = [
    'Dini biri değilim',
    'Genel spiritüel',
    'Müslüman',
    'Hristiyan',
    'Yahudi',
    'Budist',
    'Hindu',
    'Diğer',
  ];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ageGroup': ageGroup,
      'concerns': concerns,
      'goals': goals,
      'spirituality': spirituality,
      'dailyMinutes': dailyMinutes,
      'preferredTime': preferredTime,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<dynamic, dynamic> map) {
    return UserProfile(
      name: map['name'] as String? ?? '',
      ageGroup: map['ageGroup'] as String? ?? '',
      concerns: List<String>.from((map['concerns'] as List?) ?? []),
      goals: List<String>.from((map['goals'] as List?) ?? []),
      spirituality: map['spirituality'] as String? ?? 'Dini biri değilim',
      dailyMinutes: map['dailyMinutes'] as int? ?? 10,
      preferredTime: map['preferredTime'] as String? ?? 'Sabah',
      completedAt: DateTime.tryParse(map['completedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  UserProfile copyWith({
    String? name,
    String? ageGroup,
    List<String>? concerns,
    List<String>? goals,
    String? spirituality,
    int? dailyMinutes,
    String? preferredTime,
    DateTime? completedAt,
  }) {
    return UserProfile(
      name: name ?? this.name,
      ageGroup: ageGroup ?? this.ageGroup,
      concerns: concerns ?? this.concerns,
      goals: goals ?? this.goals,
      spirituality: spirituality ?? this.spirituality,
      dailyMinutes: dailyMinutes ?? this.dailyMinutes,
      preferredTime: preferredTime ?? this.preferredTime,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
