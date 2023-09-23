import 'dart:async';
import 'dart:developer';

import 'package:in_app_update/in_app_update.dart';

import 'package:get/get.dart';
import 'package:macanacki/services/controllers/IAUpdate.dart';

class IAPController extends GetxController {
  late StreamSubscription _subscription;

  var status = 'loading';

  late int selectedIndex;

  static IAPController get instance {
    try {
      return Get.find<IAPController>();
    } catch (e) {
      Get.put(IAPController());
      return Get.find<IAPController>();
    }
  }

  @override
  void onInit() {
    isInAppAvailable();
    super.onInit();
  }

  isInAppAvailable() async {
  
  }
}
