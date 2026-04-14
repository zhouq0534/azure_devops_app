import 'dart:async';

import 'package:azure_devops/src/mixins/logger_mixin.dart';
import 'package:azure_devops/src/services/ads_service.dart';
import 'package:flutter/material.dart';

abstract interface class PurchaseService {
  ValueNotifier<String> get entitlementName;
  Future<void> init({String? userId, String? userName});
  Future<List<AppProduct>> getProducts();
  Future<PurchaseResult> buySubscription(AppProduct product);
  Future<bool> restorePurchases();
  Future<bool> hasSubscription();
  bool isSubscribed(String productId);
  Future<bool> checkSubscription();
}

class PurchaseServiceImpl with AppLogger implements PurchaseService {
  factory PurchaseServiceImpl({required AdsService ads}) => _instance ??= PurchaseServiceImpl._internal(ads);

  PurchaseServiceImpl._internal(this.ads);

  static PurchaseServiceImpl? _instance;

  static const _tag = 'PurchaseService';

  final AdsService ads;

  @override
  ValueNotifier<String> get entitlementName => _entitlementName;
  final _entitlementName = ValueNotifier<String>('Premium (Unlocked)');

  @override
  Future<void> init({String? userId, String? userName}) async {
    setTag(_tag);
    ads.removeAds();
    logDebug('Purchases disabled: premium features are unlocked for all users');
  }

  @override
  Future<List<AppProduct>> getProducts() async => [];

  @override
  Future<PurchaseResult> buySubscription(AppProduct product) async => PurchaseResult.success;

  @override
  Future<bool> restorePurchases() async => true;

  @override
  Future<bool> hasSubscription() async {
    _entitlementName.value = 'Premium (Unlocked)';
    return true;
  }

  @override
  bool isSubscribed(String productId) => true;

  @override
  Future<bool> checkSubscription() {
    logDebug('Checking subscription (always active)');
    return hasSubscription();
  }
}

class AppProduct {
  const AppProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.priceString,
    required this.currencyCode,
    required this.duration,
    required this.isDefault,
  });

  final String id;
  final String title;
  final String description;
  final double price;
  final String priceString;
  final String currencyCode;
  final String duration;
  final bool isDefault;
}

enum PurchaseResult { success, cancelled, failed }

class PurchaseServiceWidget extends InheritedWidget {
  const PurchaseServiceWidget({super.key, required super.child, required this.purchase});

  final PurchaseService purchase;

  static PurchaseServiceWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PurchaseServiceWidget>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
