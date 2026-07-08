import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

import '../models/app_plan.dart';
import 'storage_service.dart';

class PurchaseService {
  PurchaseService(this._storage);

  final StorageService _storage;
  final InAppPurchase _iap = InAppPurchase.instance;
  late final StreamSubscription<List<PurchaseDetails>> _subscription;

  static const productIds = {'basic_lifetime', 'premium_lifetime'};

  Future<void> initialize() async {
    _subscription = _iap.purchaseStream.listen(_handlePurchases, onError: (_) {});
    if (await _iap.isAvailable()) {
      await _iap.restorePurchases();
    }
  }

  Future<List<ProductDetails>> products() async {
    if (!await _iap.isAvailable()) return const [];
    final response = await _iap.queryProductDetails(productIds);
    return response.productDetails;
  }

  Future<void> buy(AppPlan plan) async {
    final matches = (await products()).where((item) => item.id == plan.productId);
    final product = matches.isEmpty ? null : matches.first;
    if (product == null) return;
    await _iap.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: product));
  }

  Future<void> restore() => _iap.restorePurchases();

  Future<void> _handlePurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {
        final plan = purchase.productID == AppPlan.premium.productId ? AppPlan.premium : AppPlan.basic;
        await _storage.savePlan(plan);
      }
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  Future<void> dispose() => _subscription.cancel();
}
