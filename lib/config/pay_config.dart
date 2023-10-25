import 'package:purchases_flutter/purchases_flutter.dart';

class PayConfig {
  final Store store;
  final String apiKey;
  static PayConfig? _instance;

  factory PayConfig({required Store store, required String apiKey}) {
    _instance ??= PayConfig._internal(store, apiKey);
    return _instance!;
  }

  PayConfig._internal(this.store, this.apiKey);

  static PayConfig get instance {
    return _instance!;
  }

  static bool isForAppleStore() => instance.store == Store.appStore;

  static bool isForGooglePlay() => instance.store == Store.playStore;

  static bool isForAmazonAppstore() => instance.store == Store.amazon;
}