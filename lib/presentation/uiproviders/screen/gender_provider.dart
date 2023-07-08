import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:macanacki/presentation/model/ui_model.dart';

import '../../../model/gender_model.dart';

class GenderProvider extends ChangeNotifier {
  List<GenderSelectModel> genderModel = [
    GenderSelectModel(id: 0, gender: "Man", selected: false),
    GenderSelectModel(id: 1, gender: "Woman", selected: false),
    GenderSelectModel(id: 2, gender: "Business", selected: false),
  ];
  List<GenderList> selectedOne = [];

  List<SelectGender> genderSelect = [
    SelectGender(text: "Male", id: 0, isSelected: false),
    SelectGender(text: "Female", id: 1, isSelected: false),
    SelectGender(text: "Others", id: 2, isSelected: false),
  ];

  List<ShowMe> showMe = [
    ShowMe(title: "All", id: 0, isSelected: false),
    ShowMe(title: "Women", id: 1, isSelected: false),
    ShowMe(title: "Men", id: 2, isSelected: false),
  ];

  List<LocationSettings> locationSetting = [
    LocationSettings(
        title: "Use My Current Location",
        id: 0,
        isSelected: false,
        subtitle: "See people around your current location"),
    LocationSettings(
        title: "Use Custom Location",
        id: 1,
        isSelected: false,
        subtitle: "See people around a specific Location"),
  ];

  List<WhoYouSee> sightSettings = [
    WhoYouSee(
        title: "Balanced Recommendations",
        id: 0,
        isSelected: false,
        subtitle: "See the most relevant people to you (Default seetings)"),
    WhoYouSee(
        title: "Recently Active",
        id: 1,
        isSelected: false,
        subtitle: "See the most recently active people first"),
    WhoYouSee(
        title: "Only people You have Matched",
        id: 2,
        isSelected: false,
        subtitle: "See only people you have liked"),
  ];

  Future<void> selectGender(GenderList gender) async {
    if (selectedOne.isEmpty) {
      selectedOne.add(gender);
    } else {
      selectedOne.clear();
      selectedOne.add(gender);
    }
    notifyListeners();
  }

  void selectGenderOptions(int id, bool tick) {
    SelectGender isSelect =
        genderSelect.where((element) => element.id == id).first;
    List<SelectGender> notSelect =
        genderSelect.where((element) => element.id != id).toList();

    if (tick) {
      isSelect.isSelected = tick;
      notSelect.forEach((element) {
        element.isSelected = false;
      });
    } else {
      notSelect.forEach((element) {
        element.isSelected = false;
      });
    }

    notifyListeners();
  }

  void selectLocationSettings(int id, bool tick) {
    LocationSettings isSelect =
        locationSetting.where((element) => element.id == id).single;
    List<LocationSettings> notSelect =
        locationSetting.where((element) => element.id != id).toList();

    if (tick) {
      isSelect.isSelected = tick;
      notSelect.forEach((element) {
        element.isSelected = false;
      });
    } else {
      notSelect.forEach((element) {
        element.isSelected = false;
      });
    }

    notifyListeners();
  }

  void selectSightSettings(int id, bool tick) {
    WhoYouSee isSelect =
        sightSettings.where((element) => element.id == id).first;
    List<WhoYouSee> notSelect =
        sightSettings.where((element) => element.id != id).toList();

    if (tick) {
      isSelect.isSelected = tick;
      notSelect.forEach((element) {
        element.isSelected = false;
      });
    } else {
      notSelect.forEach((element) {
        element.isSelected = false;
      });
    }

    notifyListeners();
  }

  void selectShowMeSettings(int id, bool tick) {
    ShowMe isSelect = showMe.where((element) => element.id == id).first;
    List<ShowMe> notSelect =
        showMe.where((element) => element.id != id).toList();

    if (tick) {
      isSelect.isSelected = tick;
      notSelect.forEach((element) {
        element.isSelected = false;
      });
    } else {
      notSelect.forEach((element) {
        element.isSelected = false;
      });
    }

    notifyListeners();
  }
}
