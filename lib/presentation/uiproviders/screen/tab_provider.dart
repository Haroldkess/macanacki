import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class TabProvider extends ChangeNotifier {
  int index = 0;
  bool isChanged = false;
  int multipleImageIndex = 1;
  String image = "";
  VideoPlayerController? controller;
  VideoPlayerController? controllerHolder;
   VideoPlayerController? previousController;
  VideoPlayerController? nextController;
  bool isTapped = false;
  bool isHome = false;
  PageController? pageController = PageController();
  int tapTracker = 0;

  void tapTrack(int _index) {
    tapTracker = _index;
    notifyListeners();
  }

  void addtapTrack() {
    tapTracker += 1;
    notifyListeners();
  }

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

   Future addNextControl(VideoPlayerController control) async {
    nextController = control;
    notifyListeners();
  }

     Future addPreviousControl(VideoPlayerController control) async {
    previousController = control;
    notifyListeners();
  }

  Future addControl(VideoPlayerController control) async {
    controller = control;
    notifyListeners();
  }

  Future disposeControl() async {
    if (controller != null) {
      controller!.dispose();
      controller = null;
    }

    notifyListeners();
  }

  Future addHoldControl(VideoPlayerController control) async {
    controllerHolder = control;
    notifyListeners();
  }
    Future disposeHolldControl() async {
    if (controllerHolder != null) {
      controllerHolder!.dispose();
      controllerHolder = null;
    }

    notifyListeners();
  }

 Future disposeNextControl() async {
    if (nextController != null) {
      nextController!.dispose();
      nextController = null;
    }

    notifyListeners();
  }


 Future disposePreviousControl() async {
    if (previousController != null) {
      previousController!.dispose();
      previousController = null;
    }

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

  Future pauseNextControl() async {
    nextController!.pause();
    notifyListeners();
  }

  Future playNextControl() async {
    nextController!.play();
    notifyListeners();
  }

   Future pausePreviousControl() async {
    previousController!.pause();
    notifyListeners();
  }

  Future playPreviousControl() async {
    previousController!.play();
    notifyListeners();
  }

  Future pauseHoldControl() async {
    controllerHolder!.pause();
    notifyListeners();
  }

  Future playHoldControl() async {
    controllerHolder!.play();
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
