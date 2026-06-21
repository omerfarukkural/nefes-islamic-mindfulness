import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/mizac/domain/mizac_model.dart';
import '../services/offline_storage_service.dart';

class MizacNotifier extends StateNotifier<MizacType?> {
  MizacNotifier() : super(null) {
    _load();
  }

  void _load() {
    final saved = OfflineStorageService.getSetting('mizac_type');
    if (saved != null) {
      try {
        state = MizacTypeExt.fromName(saved as String);
      } catch (_) {}
    }
  }

  Future<void> setMizac(MizacType type) async {
    state = type;
    await OfflineStorageService.saveSetting('mizac_type', type.name);
  }

  Future<void> clearMizac() async {
    state = null;
    await OfflineStorageService.saveSetting('mizac_type', null);
  }
}

final mizacProvider =
    StateNotifierProvider<MizacNotifier, MizacType?>((ref) => MizacNotifier());
