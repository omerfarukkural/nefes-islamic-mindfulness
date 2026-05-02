import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_profile_provider.dart';

class DailyContent {
  final String text;
  final String source;

  const DailyContent({required this.text, required this.source});

  factory DailyContent.fromMap(Map<String, dynamic> map) {
    return DailyContent(
      text: map['text'] as String,
      source: map['source'] as String,
    );
  }
}

final dailyContentProvider = FutureProvider<DailyContent>((ref) async {
  final profile = ref.watch(userProfileProvider);
  final spirituality = profile?.spirituality ?? 'Dini biri değilim';

  final jsonString =
      await rootBundle.loadString('assets/data/daily_content.json');
  final data = jsonDecode(jsonString) as Map<String, dynamic>;

  String key;
  switch (spirituality) {
    case 'Müslüman':
      key = 'muslim';
    case 'Hristiyan':
      key = 'christian';
    case 'Yahudi':
      key = 'jewish';
    case 'Budist':
      key = 'buddhist';
    case 'Hindu':
      key = 'hindu';
    case 'Genel spiritüel':
      key = 'spiritual';
    default:
      key = 'general';
  }

  final List<dynamic> items = data[key] as List<dynamic>? ?? data['general'] as List<dynamic>;

  // Pick item based on day of year so it rotates daily
  final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
  final index = dayOfYear % items.length;

  return DailyContent.fromMap(items[index] as Map<String, dynamic>);
});
