import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class FacialWare extends ChangeNotifier {
  bool _loadStatus = false;
  File? facial;
  File? addedPhoto;
  File? addedDp;

  bool get loadStatus => _loadStatus;

  void isLoading(bool isLoad) {
    _loadStatus = isLoad;
    notifyListeners();
  }

  void addFacialFile(XFile file) {
    facial = File(file.path);
    notifyListeners();
  }

  void addPhoto(XFile photo) {
    addedPhoto = File(photo.path);
    notifyListeners();
  }

  Future<void> addDp(XFile photo) async {
    addedDp = File(photo.path);
    notifyListeners();
  }
}
