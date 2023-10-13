import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';

class PostSecurity extends GetxController {
  static PostSecurity get instance {
    return Get.find<PostSecurity>();
  }

  RxBool isSecure = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
   // secure();
  }

  void secure() {
    // if (isSecure.value) {
    //   if (GetPlatform.isAndroid) {
    //     FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    //   }
    // } else {
    //   if (GetPlatform.isAndroid) {
    //     FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    //   }
    // }
   // update();
  }

  void toggleSecure(bool val) {
    isSecure.value = val;
    secure();
  }
}
