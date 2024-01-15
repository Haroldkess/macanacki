import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ChatProvider extends GetxController {
  static ChatProvider get instance {
    return Get.find<ChatProvider>();
  }

  RxInt id = 0.obs;
  RxList<int> idList = <int>[].obs;

  Future changeId(int data) async {
    id.value = data;
    if (data != 0) {
      idList.add(data);
    }
    //update();
  }
}
