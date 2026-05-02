import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_profile.dart';

const String _userProfileBoxName = 'user_profile';
const String _userProfileKey = 'profile';

class UserProfileNotifier extends Notifier<UserProfile?> {
  @override
  UserProfile? build() {
    final box = Hive.box(_userProfileBoxName);
    final raw = box.get(_userProfileKey);
    if (raw == null) return null;
    return UserProfile.fromMap(raw as Map);
  }

  Future<void> saveProfile(UserProfile profile) async {
    final box = Hive.box(_userProfileBoxName);
    await box.put(_userProfileKey, profile.toMap());
    state = profile;
  }

  Future<void> clearProfile() async {
    final box = Hive.box(_userProfileBoxName);
    await box.delete(_userProfileKey);
    state = null;
  }
}

final userProfileProvider =
    NotifierProvider<UserProfileNotifier, UserProfile?>(
  UserProfileNotifier.new,
);

/// Returns which feature categories are relevant for the current user profile.
final activeConcernsProvider = Provider<Set<String>>((ref) {
  final profile = ref.watch(userProfileProvider);
  if (profile == null) return {};
  return profile.concerns.toSet();
});

/// Returns whether the user has a completed profile.
final hasProfileProvider = Provider<bool>((ref) {
  final profile = ref.watch(userProfileProvider);
  return profile != null && profile.name.isNotEmpty;
});
