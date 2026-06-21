import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/app.dart';
import 'core/services/offline_storage_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/admob_service.dart';
import 'core/services/purchase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // Firebase config missing in dev — continue without it
  }

  // Hive (offline depolama)
  await Hive.initFlutter();
  await OfflineStorageService.initializeBoxes();

  if (!kIsWeb) {
    await NotificationService.initialize();
    await AdMobService.initialize();
    AdMobService.loadInterstitialAd();
    AdMobService.loadRewardedAd();
    await PurchaseService.initialize();
  }

  runApp(
    const ProviderScope(
      child: NefesApp(),
    ),
  );
}
