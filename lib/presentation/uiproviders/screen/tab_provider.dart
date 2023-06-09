import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class TabProvider extends ChangeNotifier {
  int index = 0;
  bool isChanged = false;
  int multipleImageIndex = 1;
  String image = "";
  VideoPlayerController? controller;
  VideoPlayerController? controllerHolder;
  bool isTapped = false;
  bool isHome = false;
  PageController? pageController = PageController();

  void addPageControl(PageController page) {
    pageController = page;
    notifyListeners();
  }

  void tap(bool val) {
    isTapped = val;
    notifyListeners();
  }
 void isHomeChange(bool val) {
    isHome = val;
    notifyListeners();
  }
  void changeMultipleIndex(int page) {
    multipleImageIndex = page;
    notifyListeners();
  }

  Future addControl(VideoPlayerController control) async {
    controller = control;
    notifyListeners();
  }

  Future addHoldControl(VideoPlayerController control) async {
    controllerHolder = control;
    notifyListeners();
  }

  Future pauseControl() async {
    controller!.pause();
    notifyListeners();
  }

  Future playControl() async {
    controller!.play();
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
