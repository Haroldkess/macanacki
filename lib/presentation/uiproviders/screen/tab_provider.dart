import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class TabProvider extends ChangeNotifier {
  int index = 0;
  bool isChanged = false;
  int multipleImageIndex = 1;
  String image = "";
  VideoPlayerController? controller;

  void changeMultipleIndex(int page) {
    multipleImageIndex = page;
    notifyListeners();
  }
    Future addControl(VideoPlayerController control) async {
    controller = control;
    notifyListeners();
  }
    Future disControl() async {
    controller!.dispose();
    notifyListeners();
  }

  void changeMultipleImage(String img) {
    image = img;
    notifyListeners();
  }

  void changeIndex(int _index) {
    index = _index;
    notifyListeners();
  }

  Future<void> changePage(bool change) async {
    isChanged = change;
    notifyListeners();
  }
}
