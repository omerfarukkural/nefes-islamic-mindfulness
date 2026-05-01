import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

enum SubscriptionTier { free, premium, lifetime }

class PurchaseService {
  static const String _monthlySubId = 'nefes_premium_monthly';
  static const String _yearlySubId = 'nefes_premium_yearly';
  static const String _lifetimeId = 'nefes_lifetime';

  static const Set<String> _kProductIds = {
    _monthlySubId,
    _yearlySubId,
    _lifetimeId,
  };

  static final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  static StreamSubscription<List<PurchaseDetails>>? _subscription;
  static List<ProductDetails> _products = [];
  static SubscriptionTier _currentTier = SubscriptionTier.free;

  static SubscriptionTier get currentTier => _currentTier;
  static List<ProductDetails> get products => _products;

  static bool get isPremium => _currentTier != SubscriptionTier.free;

  static Future<void> initialize() async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      debugPrint('In-App Purchase mevcut değil');
      return;
    }

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdated,
      onDone: () => _subscription?.cancel(),
      onError: (error) => debugPrint('Satın alma hatası: $error'),
    );

    await _loadProducts();
  }

  static Future<void> _loadProducts() async {
    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(_kProductIds);
    if (response.error != null) {
      debugPrint('Ürünler yüklenemedi: ${response.error}');
      return;
    }
    _products = response.productDetails;
    debugPrint('${_products.length} ürün yüklendi');
  }

  static Future<void> buyMonthly() async {
    await _buyProduct(_monthlySubId);
  }

  static Future<void> buyYearly() async {
    await _buyProduct(_yearlySubId);
  }

  static Future<void> buyLifetime() async {
    await _buyProduct(_lifetimeId);
  }

  static Future<void> _buyProduct(String productId) async {
    final ProductDetails? product = _products
        .where((p) => p.id == productId)
        .firstOrNull;

    if (product == null) {
      debugPrint('Ürün bulunamadı: $productId');
      return;
    }

    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: product);

    if (productId == _lifetimeId) {
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } else {
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  static Future<void> restorePurchases() async {
    await _inAppPurchase.restorePurchases();
  }

  static void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        debugPrint('Satın alma bekliyor...');
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        _verifyAndDeliverProduct(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        debugPrint('Satın alma hatası: ${purchaseDetails.error}');
      }

      if (purchaseDetails.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  static void _verifyAndDeliverProduct(PurchaseDetails purchaseDetails) {
    if (purchaseDetails.productID == _monthlySubId ||
        purchaseDetails.productID == _yearlySubId) {
      _currentTier = SubscriptionTier.premium;
    } else if (purchaseDetails.productID == _lifetimeId) {
      _currentTier = SubscriptionTier.lifetime;
    }
    debugPrint('Premium aktif: ${_currentTier.name}');
  }

  static void dispose() {
    _subscription?.cancel();
  }

  // Fiyat bilgisi al
  static String getMonthlyPrice() {
    return _products
        .where((p) => p.id == _monthlySubId)
        .firstOrNull?.price ?? '₺79,99';
  }

  static String getYearlyPrice() {
    return _products
        .where((p) => p.id == _yearlySubId)
        .firstOrNull?.price ?? '₺399,99';
  }

  static String getLifetimePrice() {
    return _products
        .where((p) => p.id == _lifetimeId)
        .firstOrNull?.price ?? '₺999,99';
  }
}