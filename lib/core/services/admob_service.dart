import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

class AdMobService {
  static const String _bannerAdUnitIdAndroid = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String _interstitialAdUnitIdAndroid = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String _rewardedAdUnitIdAndroid = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';

  // TEST ID'leri (geliştirme sırasında kullan)
  static const String _testBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String _testRewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';

  static bool _useTestAds = kDebugMode;

  static String get bannerAdUnitId {
    if (_useTestAds) return _testBannerAdUnitId;
    if (kIsWeb) return '';
    return Platform.isAndroid ? _bannerAdUnitIdAndroid : _testBannerAdUnitId;
  }

  static String get interstitialAdUnitId {
    if (_useTestAds) return _testInterstitialAdUnitId;
    return Platform.isAndroid ? _interstitialAdUnitIdAndroid : _testInterstitialAdUnitId;
  }

  static String get rewardedAdUnitId {
    if (_useTestAds) return _testRewardedAdUnitId;
    return Platform.isAndroid ? _rewardedAdUnitIdAndroid : _testRewardedAdUnitId;
  }

  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: kDebugMode ? ['YOUR_TEST_DEVICE_ID'] : [],
      ),
    );
  }

  // Banner Reklam
  static BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => debugPrint('Banner reklam yüklendi'),
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner reklam yüklenemedi: $error');
          ad.dispose();
        },
      ),
    );
  }

  // Geçiş Reklamı (Her 3 meditasyondan sonra göster)
  static InterstitialAd? _interstitialAd;
  static int _numInterstitialLoadAttempts = 0;
  static const int _maxFailedLoadAttempts = 3;

  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts < _maxFailedLoadAttempts) {
            loadInterstitialAd();
          }
        },
      ),
    );
  }

  static void showInterstitialAd() {
    if (_interstitialAd == null) {
      loadInterstitialAd();
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        loadInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  // Ödüllü Reklam (Premium içerik kilidi açmak için)
  static RewardedAd? _rewardedAd;

  static void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _rewardedAd = null;
          debugPrint('Ödüllü reklam yüklenemedi: $error');
        },
      ),
    );
  }

  static void showRewardedAd({required Function(RewardItem) onRewarded}) {
    if (_rewardedAd == null) {
      loadRewardedAd();
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
        loadRewardedAd();
      },
    );
    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        onRewarded(reward);
      },
    );
    _rewardedAd = null;
  }
}