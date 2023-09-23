import 'package:flutter/cupertino.dart';
import 'dart:io';

class VideoTrimmerWare extends ChangeNotifier {
  bool _progressVisibility = false;
  String _caption = '';
  double _startValue = 0.0;
  double _endValue = 0.0;
  bool _isPlaying = false;

  void updateProgressVisibility(bool value) {
    _progressVisibility = value;
    notifyListeners();
  }

  void updateCaption(String value) {
    _caption = value;
    notifyListeners();
  }

  void updateStartValue(double value) {
    if (value.isNaN || value.isInfinite) return;
    _startValue = value;
    notifyListeners();
  }

  void updateEndValue(double value) {
    if (value.isNaN || value.isInfinite) return;
    _endValue = value;
    notifyListeners();
  }

  void updateIsPlaying(bool value) {
    _isPlaying = value;
    notifyListeners();
  }

  double getFileSize(File file) {
    int sizeInBytes = file.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    return sizeInMb;
  }

  //GETTER
  bool get progressVisibility => _progressVisibility;
  bool get isPlaying => _isPlaying;
  double get startValue => _startValue;
  double get endValue => _endValue;
  String get caption => _caption;
}
