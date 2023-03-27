import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/screens/home/profile/createpost/create_post_screen.dart';
import 'package:makanaki/presentation/uiproviders/dob/dob_provider.dart';
import 'package:makanaki/presentation/uiproviders/screen/comment_provider.dart';
import 'package:makanaki/presentation/uiproviders/screen/find_people_provider.dart';
import 'package:makanaki/presentation/uiproviders/screen/gender_provider.dart';
import 'package:makanaki/services/controllers/login_controller.dart';
import 'package:makanaki/services/middleware/gender_ware.dart';
import 'package:makanaki/services/temps/temp.dart';
import 'package:makanaki/services/temps/temps_id.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/feed_post_model.dart';
import '../model/gender_model.dart';
import 'package:image_picker/image_picker.dart';

import '../services/middleware/create_post_ware.dart';
import '../services/middleware/facial_ware.dart';

class Operations {
  static Future delayScreen(BuildContext context, Widget page) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.containsKey(isLoggedInKey)) {
      if (pref.getBool(isLoggedInKey) == true) {
        if (pref.containsKey(emailKey) && pref.containsKey(passwordKey)) {
          // ignore: use_build_context_synchronously
          await LoginController.loginUserController(context,
              pref.getString(emailKey)!, pref.getString(passwordKey)!, true);
        } else {
          await Future.delayed(const Duration(seconds: 3), () {
            print("will send ui to first screen in 3 seconds");
          }).whenComplete(() => PageRouting.removeAllToPage(context, page));
        }
      } else {
        await Future.delayed(const Duration(seconds: 3), () {
          print("will send ui to first screen in 3 seconds");
        }).whenComplete(() => PageRouting.removeAllToPage(context, page));
      }
    } else {
      await Future.delayed(const Duration(seconds: 3), () {
        print("will send ui to first screen in 3 seconds");
      }).whenComplete(() => PageRouting.removeAllToPage(context, page));
    }
  }

  // select gender
  static Future funcAddGender(BuildContext context, GenderList e) async {
    genderWare provide = Provider.of<genderWare>(context, listen: false);
    Future.delayed(const Duration(seconds: 0), () {
      provide.selectGenderOptions(e.id!, e.selected!);
    }).whenComplete(() => log('func ran, gender selected'));
  }

  static Future funcChangeDob(BuildContext context, DateTime dob) async {
    DobProvider provide = Provider.of<DobProvider>(context, listen: false);
    String formattedDate = DateFormat('MM-yyyy').format(dob);

    await Future.delayed(Duration.zero, () async {
      provide.changeDob(dob);
    }).whenComplete(() => log("dob changed successfully"));
  }

  static Future funcFindUser(
    BuildContext context,
  ) async {
    FindPeopleProvider provide =
        Provider.of<FindPeopleProvider>(context, listen: false);

    Future.delayed(const Duration(seconds: 3), () {
      provide.found(true);
    }).whenComplete(() => log("search  complete "));
  }

  static Future selectGenderOption(
      BuildContext context, int id, bool tick) async {
    genderWare provide = Provider.of<genderWare>(context, listen: false);

    provide.selectGenderOptions(id, tick);
  }

  static Future selectDescoveryOption(
      BuildContext context, int id, bool tick) async {
    GenderProvider provide =
        Provider.of<GenderProvider>(context, listen: false);

    provide.selectLocationSettings(id, tick);
  }

  static Future selectSightOption(
      BuildContext context, int id, bool tick) async {
    GenderProvider provide =
        Provider.of<GenderProvider>(context, listen: false);

    provide.selectSightSettings(id, tick);
  }

  static Future selectShowMeOption(
      BuildContext context, int id, bool tick) async {
    GenderProvider provide =
        Provider.of<GenderProvider>(context, listen: false);

    provide.selectShowMeSettings(id, tick);
  }

  static Future verifyFaceCamera(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    late XFile? _imageFile;
    FacialWare facial = Provider.of<FacialWare>(context, listen: false);
    try {
      final XFile? file = await _picker.pickImage(
          source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);

      if (file != null) {
        _imageFile = file;
        log(_imageFile.path);
        facial.addFacialFile(_imageFile);
        facial.isLoading(true);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future addPhotoFromGallery(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    late XFile? _imageFile;
    FacialWare facial = Provider.of<FacialWare>(context, listen: false);
    try {
      final XFile? file = await _picker.pickImage(
          source: ImageSource.gallery,
          preferredCameraDevice: CameraDevice.rear);

      if (file != null) {
        _imageFile = file;
        log(_imageFile.path);
        facial.addPhoto(_imageFile);
        facial.isLoading(true);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future pickForPost(BuildContext context) async {
    CreatePostWare picked = Provider.of<CreatePostWare>(context, listen: false);
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'mp4'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        log(file.path.toString());
        picked.addFile(file);
        // ignore: use_build_context_synchronously
        PageRouting.pushToPage(context, CreatePostScreen());
      } else {
        // User canceled the picker
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future commentOperation(BuildContext context, bool isAdd,
      [List<dynamic>? commentList, Comment? data]) async {
    StoreComment comment = Provider.of<StoreComment>(context, listen: false);
    if (isAdd == false) {
      comment.addAllComments(commentList!);
    } else {
      comment.addSingleComment(data!);
    }
  }
}


