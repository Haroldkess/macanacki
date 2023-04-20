import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/screens/home/profile/createpost/create_post_screen.dart';
import 'package:makanaki/presentation/uiproviders/dob/dob_provider.dart';
import 'package:makanaki/presentation/uiproviders/screen/comment_provider.dart';
import 'package:makanaki/presentation/uiproviders/screen/find_people_provider.dart';
import 'package:makanaki/presentation/uiproviders/screen/gender_provider.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/controllers/login_controller.dart';
import 'package:makanaki/services/controllers/mode_controller.dart';
import 'package:makanaki/services/middleware/gender_ware.dart';
import 'package:makanaki/services/temps/temps_id.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
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
          await Future.delayed(const Duration(seconds: 3), () {})
              .whenComplete(() => PageRouting.removeAllToPage(context, page));
        }
      } else {
        await Future.delayed(const Duration(seconds: 3), () {})
            .whenComplete(() => PageRouting.removeAllToPage(context, page));
      }
    } else {
      await Future.delayed(const Duration(seconds: 3), () {})
          .whenComplete(() => PageRouting.removeAllToPage(context, page));
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
    // String formattedDate = DateFormat('MM-yyyy').format(dob);

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
    final ImagePicker picker = ImagePicker();
    late XFile? imageFile;
    FacialWare facial = Provider.of<FacialWare>(context, listen: false);
    try {
      final XFile? file = await picker.pickImage(
          source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);

      if (file != null) {
        imageFile = file;
        log(imageFile.path);
        facial.addFacialFile(imageFile);
        // facial.isLoading(true);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future addPhotoFromGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    late XFile? imageFile;
    FacialWare facial = Provider.of<FacialWare>(context, listen: false);
    try {
      final XFile? file = await picker.pickImage(
          source: ImageSource.gallery,
          preferredCameraDevice: CameraDevice.rear);

      if (file != null) {
        imageFile = file;
        log(imageFile.path);
        facial.addPhoto(imageFile);
        // facial.isLoading(true);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future changePhotoFromGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    late XFile? imageFile;
    FacialWare facial = Provider.of<FacialWare>(context, listen: false);
    try {
      final XFile? file = await picker.pickImage(
          source: ImageSource.gallery,
          preferredCameraDevice: CameraDevice.rear);

      if (file != null) {
        imageFile = file;
        log(imageFile.path);
        facial.addDp(imageFile);
        // facial.isLoading(true);
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
        PageRouting.pushToPage(context, const CreatePostScreen());
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

  static String times(DateTime time) {
    late String realTime;

    String value = timeago.format(time).toString();
    String timeOfDay =
        TimeOfDay(hour: time.hour, minute: time.minute).period.name;

    if (value == "a moment ago") {
      realTime = "just now";
    } else if (value == "a minute ago") {
      realTime = value;
    } else if (value.contains("hour")) {
      realTime = "${time.hour}:${time.minute}";
    } else if (value.contains("hours")) {
      realTime = "${time.hour}:${time.minute} $timeOfDay";
    } else if (value == 'a day ago') {
      realTime = "yesterday ${time.hour}:${time.minute} $timeOfDay";
    } else if (value.contains("days")) {
      realTime = "$value ${time.hour}:${time.minute} $timeOfDay";
    } else {
      realTime = value;
    }

    return realTime;
  }

  static Future<bool?> showWarning(BuildContext context) async {
    late bool? isClolsing;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 10.0,
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 3),
      content: Row(
        children: [
          AppText(
            text: "Sure you want to exit?",
            color: Colors.white,
            size: 15,
            fontWeight: FontWeight.w600,
          )
        ],
      ),
      backgroundColor: HexColor(primaryColor).withOpacity(.9),
      action: SnackBarAction(
          label: "Yes",
          textColor: Colors.white,
          onPressed: () async {
            await ModeController.handleMode("offline");
            isClolsing = true;
          }),
    ));

    await Future.delayed(const Duration(seconds: 2)).whenComplete(() {
      isClolsing ??= false;
      if (isClolsing == true) {
        isClolsing = true;
      } else {
        isClolsing = false;
      }
    });

    return isClolsing;
  }
}
