import 'package:azure_devops/src/mixins/logger_mixin.dart';
import 'package:azure_devops/src/models/amazon/amazon_item.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract interface class AdsService {
  bool get hasAmazonAds;
  Future<void> init();
  Future<void> showInterstitialAd({VoidCallback? onDismiss});
  void removeAds();
  void reactivateAds();
  Future<List<AdWithView>> getNewNativeAds();
  Future<List<AmazonItem>> getNewAmazonAds();
}

class AdsServiceImpl with AppLogger implements AdsService {
  factory AdsServiceImpl() => _instance ??= AdsServiceImpl._internal();

  AdsServiceImpl._internal();

  static AdsServiceImpl? _instance;

  static const _tag = 'AdsService';

  @override
  bool get hasAmazonAds => false;

  @override
  Future<void> init() async {
    setTag(_tag);
    logDebug('Ads disabled');
  }

  @override
  Future<void> showInterstitialAd({VoidCallback? onDismiss}) async {
    onDismiss?.call();
  }

  @override
  void removeAds() {}

  @override
  void reactivateAds() {}

  @override
  Future<List<AdWithView>> getNewNativeAds() async => [];

  @override
  Future<List<AmazonItem>> getNewAmazonAds() async => [];
}

class AdsServiceWidget extends InheritedWidget {
  const AdsServiceWidget({super.key, required super.child, required this.ads});

  final AdsService ads;

  static AdsServiceWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AdsServiceWidget>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
