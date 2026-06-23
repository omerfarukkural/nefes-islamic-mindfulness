import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';

class ProfileNotifier extends StateNotifier<UserProfile?> {
  ProfileNotifier() : super(null) {
    _load();
  }

  void _load() {
    state = UserProfile.load();
  }

  Future<void> save(UserProfile profile) async {
    await profile.save();
    state = profile;
  }

  Future<void> updateMizac(String mizac) async {
    final current = state;
    if (current == null) return;
    final updated = UserProfile(
      name: current.name,
      arabicName: current.arabicName,
      birthDate: current.birthDate,
      gender: current.gender,
      mizac: mizac,
    );
    await save(updated);
  }

  void reload() {
    state = UserProfile.load();
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile?>(
    (ref) => ProfileNotifier());
