import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ButtonState extends ChangeNotifier {
  static ButtonState get instance {
    return Get.find<ButtonState>();
  }

  RxBool toggleDiscription = false.obs;
  void tapOpen() {
    if (toggleDiscription.value == false) {
      toggleDiscription.value = true;
    }
  }

  void tapClose() {
    if (toggleDiscription.value) {
      toggleDiscription.value = false;
    }
  }
}
