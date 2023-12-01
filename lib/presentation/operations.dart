import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:hexcolor/hexcolor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/home/profile/createpost/create_post_screen.dart';
import 'package:macanacki/presentation/screens/onboarding/business/business_info.dart';
import 'package:macanacki/presentation/screens/onboarding/business/business_verification.dart';
import 'package:macanacki/presentation/screens/onboarding/business/sub_plan.dart';
import 'package:macanacki/presentation/uiproviders/dob/dob_provider.dart';
import 'package:macanacki/presentation/uiproviders/screen/comment_provider.dart';
import 'package:macanacki/presentation/uiproviders/screen/find_people_provider.dart';
import 'package:macanacki/presentation/uiproviders/screen/gender_provider.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/presentation/widgets/dialogue.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/controllers/login_controller.dart';
import 'package:macanacki/services/controllers/mode_controller.dart';
import 'package:macanacki/services/middleware/gender_ware.dart';
import 'package:macanacki/services/middleware/swipe_ware.dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:multi_image_crop/multi_image_crop.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../model/feed_post_model.dart';
import '../model/gender_model.dart';
import 'package:image_picker/image_picker.dart';

import '../services/controllers/plan_controller.dart';
import '../services/controllers/user_profile_controller.dart';
import '../services/middleware/chat_ware.dart';
import '../services/middleware/create_post_ware.dart';
import '../services/middleware/facial_ware.dart';
import '../services/middleware/plan_ware.dart';
import 'constants/params.dart';

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
        emitter(imageFile.path);
        facial.addFacialFile(imageFile);
        // facial.isLoading(true);
      }
    } catch (e) {
      emitter(e.toString());
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
        // emitter(imageFile.path);
        facial.addPhoto(imageFile);
        // facial.isLoading(true);
      }
    } catch (e) {
      emitter(e.toString());
    }
  }

  static Future changePhotoFromGallery(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final ImagePicker picker = ImagePicker();
    //late XFile? imageFile;
    FacialWare facial = Provider.of<FacialWare>(context, listen: false);
    print("xxxxxxxxxxxxxxxxxxxxxx");
    try {
      if (await Permission.storage.request().isGranted) {
        // Call FilePicker.platform.pickFiles in here

        final XFile? file = await picker.pickImage(
            source: ImageSource.gallery,
            preferredCameraDevice: CameraDevice.rear,
            requestFullMetadata: true);

        print("xxxxxxxxxxxxxxxxxxxxxx  1111");

        if (file != null) {
          XFile imageFile = file;
          emitter("FilePath: ${file.path}");

          //Lets crop image
          CroppedFile? croppedFile = await ImageCropper().cropImage(
            sourcePath: imageFile.path,
            cropStyle: CropStyle.rectangle,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              // CropAspectRatioPreset.ratio3x2,
              // CropAspectRatioPreset.original,
              // CropAspectRatioPreset.ratio4x3,
              // CropAspectRatioPreset.ratio16x9
            ],
            uiSettings: [
              AndroidUiSettings(
                  toolbarTitle: 'Crop Image',
                  toolbarColor: HexColor(darkColor),
                  toolbarWidgetColor: Colors.white,
                  initAspectRatio: CropAspectRatioPreset.square,
                  lockAspectRatio: true),
              IOSUiSettings(
                title: '',
              ),
            ],
          );

          print("xxxxxxxxxxxxxxxxxxxxxx  22222222");

          if (croppedFile == null) return;
          XFile croppedFileX = XFile(croppedFile.path);

          print("xxxxxxxxxxxxxxxxxxxxxx 3333333");

          pref.setString(temPhotoKey, croppedFileX.path);
          emitter("FilePath after cropping: ${croppedFileX.path}");

          print("xxxxxxxxxxxxxxxxxxxxxx 4444");

          facial.addDp(croppedFileX);
          // pref.setString(temPhotoKey, imageFile.path);
          // facial.isLoading(true);
        }
      }
    } catch (e) {
      emitter(e.toString());
    }
  }

  static Future<File> saveImage(Uint8List imageByte) async {
    //获取临时目录
    var tempDir = await getTemporaryDirectory();
    //生成file文件格式
    var file =
        await File('${tempDir.path}/image_${DateTime.now().millisecond}.jpg')
            .create();
    //转成file文件
    file.writeAsBytesSync(imageByte);
    return file;
    // print("${file.path}");
    // setState(() {
    //   path = file.path;
    //   // turn(file);
    //   _imageUint8=imageByte;
    // });
  }

  static Future pickForPost(BuildContext context) async {
    CreatePostWare picked = Provider.of<CreatePostWare>(context, listen: false);

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,

          //   allowedExtensions: ['jpg','png','jpeg'],
          allowMultiple: true);

      if (result != null) {
        //   PlatformFile filex = result.files.first;

        List<File> file = result.paths.map((path) => File(path!)).toList();

        if (file.length > 10) {
          // ignore: use_build_context_synchronously
          showToast2(context, "You can only select maximum of 10 media files",
              isError: true);
          return;
        }

        // if (user.userProfileModel.verified == null ||
        //     (user.userProfileModel.verified == 0 &&
        //         user.userProfileModel.gender != "Business")) {
        //   emitter("selected file lenght ${file.length.toString()}");
        //   if (file.length > 1) {
        //     // ignore: use_build_context_synchronously
        //     errors(context);

        //     return;
        //   }
        // } else {
        //   if ((user.userProfileModel.verified == 1 &&
        //       user.userProfileModel.gender == "Business")) {
        //     if (file.length > 10) {
        //       // ignore: use_build_context_synchronously
        //       showToast2(
        //           context, "You can only select maximum of 10 media files",
        //           isError: true);
        //       return;
        //     }
        //   } else if ((user.userProfileModel.verified == 0 &&
        //       user.userProfileModel.gender == "Business")) {
        //     if (file.length > 1) {
        //       // ignore: use_build_context_synchronously
        //       errors(context);

        //       return;
        //     }
        //   } else {
        //     if (file.length > 1) {
        //       // ignore: use_build_context_synchronously
        //       errors(context);

        //       return;
        //     }
        //   }
        // }

        //  emitter(file.first.path.toString());
        picked.addFile(file);
        // ignore: use_build_context_synchronously
        PageRouting.pushToPage(context, const CreatePostScreen());
      } else {
        // User canceled the picker
      }
    } catch (e) {
      emitter(e.toString());
    }
  }

  static Future errors(context) async {
    showToast2(context, "You can only select maximum of 1 media files",
        isError: true);

    await Future.delayed(Duration(seconds: 4));
    // ignore: use_build_context_synchronously
    try {
      // ignore: use_build_context_synchronously
      showToast2(context, "Become a verified Business to post more media files",
          isError: false);
    } catch (e) {
      showToastLater("Become a verified Business to post more media files");
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

    if (realTime.contains("about")) {
      var val = realTime.split("about");

      realTime = val.last;
    }

    return realTime;
  }

  static String feedTimes(DateTime time) {
    late String realTime;

    String value = timeago.format(time).toString();
    // String timeOfDay =
    //     TimeOfDay(hour: time.hour, minute: time.minute).period.name;

    if (value == "a moment ago") {
      realTime = "just now";
    } else if (value == "a minute ago") {
      realTime = value;
    } else if (value.contains("hour")) {
      realTime = value;
    } else if (value.contains("hours")) {
      realTime = value;
    } else if (value == 'a day ago') {
      realTime = "yesterday";
    } else if (value.contains("days")) {
      realTime = "$value ";
    } else {
      realTime = value;
    }

    if (realTime.contains("about")) {
      var val = realTime.split("about");

      realTime = val.last;
    }
    //  emitter("Time is" + value);

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

  static Future pickId(BuildContext context, bool isUser) async {
    CreatePostWare picked = Provider.of<CreatePostWare>(context, listen: false);
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.media,
          //allowedExtensions: ['jpg', 'pdf'],
          allowMultiple: false);

      if (result != null) {
        List<File> file = result.paths.map((path) => File(path!)).toList();
        if (file.length > 1) {
          // ignore: use_build_context_synchronously
          showToast2(context, "You can only select maximum of 1 files",
              isError: true);
          return;
        }

        //  emitter(file.first.path.toString());
        if (isUser) {
          picked.addIdUser(file.first);
        } else {
          picked.addIdBusiness(file.first);
        }
      } else {
        // User canceled the picker
      }
    } catch (e) {
      emitter(e.toString());
    }
  }

  static Future pickAudio(BuildContext context) async {
    CreatePostWare picked = Provider.of<CreatePostWare>(context, listen: false);
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['mp3'],
          allowMultiple: false,
          withData: true,
          withReadStream: true);

      if (result != null) {
        List<File> file = result.paths.map((path) => File(path!)).toList();
        if (file.length > 1) {
          // ignore: use_build_context_synchronously
          showToast2(context, "You can only select maximum of 1 audio file",
              isError: true);
          return;
        }
        picked.addAudio(file.first);
      } else {
        // User canceled the picker
      }
    } catch (e) {
      emitter(e.toString());
    }
  }

  static Future pickCoverOfAudio(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final ImagePicker picker = ImagePicker();
    late XFile? imageFile;
    CreatePostWare picked = Provider.of<CreatePostWare>(context, listen: false);
    try {
      if (await Permission.storage.request().isGranted) {
        // Call FilePicker.platform.pickFiles in here

        final XFile? file = await picker.pickImage(
            source: ImageSource.gallery,
            preferredCameraDevice: CameraDevice.rear,
            requestFullMetadata: true);

        if (file != null) {
          imageFile = file;
          emitter("FilePath: ${file.path}");

          //Lets crop image
          CroppedFile? croppedFile = await ImageCropper().cropImage(
            sourcePath: imageFile.path,
            cropStyle: CropStyle.rectangle,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              // CropAspectRatioPreset.ratio3x2,
              // CropAspectRatioPreset.original,
              // CropAspectRatioPreset.ratio4x3,
              // CropAspectRatioPreset.ratio16x9
            ],
            uiSettings: [
              AndroidUiSettings(
                  toolbarTitle: 'Crop Image',
                  toolbarColor: HexColor(darkColor),
                  toolbarWidgetColor: Colors.white,
                  initAspectRatio: CropAspectRatioPreset.square,
                  lockAspectRatio: true),
              IOSUiSettings(
                title: '',
              ),
            ],
          );

          if (croppedFile == null) return;
          XFile croppedFileX = XFile(croppedFile.path);

          pref.setString(temPhotoKey, croppedFileX.path);
          emitter("FilePath after cropping: ${croppedFileX.path}");

          picked.addAudioCoverFile(croppedFileX);
          // pref.setString(temPhotoKey, imageFile.path);
          // facial.isLoading(true);
        }
      }
    } catch (e) {
      emitter(e.toString());
    }
  }

  static Future stopCommentLoad(context) async {
    CreatePostWare ware = Provider.of<CreatePostWare>(context, listen: false);
    ware.isLoading2(false);
  }

  static Future<void> searchInConversations(
      BuildContext context, String text) async {
    ChatWare action = Provider.of<ChatWare>(context, listen: false);
    action.addToSearch(text);
  }

  static Future controlSystemColor() async {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: Colors.black,
    //     statusBarIconBrightness: Brightness.light,
    //     systemNavigationBarIconBrightness: Brightness.dark,
    //     systemNavigationBarColor: HexColor(backgroundColor)));
  }

  static Future<void> filterLocaton(context,
      [String? country, state, city]) async {
    SwipeWare ware = Provider.of<SwipeWare>(context, listen: false);
    if (country != null) {
      ware.filterByCountry(country);
    }
    if (state != null) {
      ware.filterByState(state);
    }
    if (city != null) {
      ware.filterByCity(city);
    }
  }

  static Future checkNewlyVerified() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey(isVerifiedKey)) {
      if (pref.getBool(isVerifiedKey) == true &&
          pref.getBool(isVerifiedFirstKey) == false) {
        Get.dialog(
            verifiedDialog(
                title: "Congratulations",
                message: "Your account has been verified.",
                confirmText: "Okay",
                cancelText: "Go back",
                onPressedCancel: () {
                  pref.setBool(isVerifiedFirstKey, true);
                  Get.back();
                },
                onPressed: () {
                  pref.setBool(isVerifiedFirstKey, true);
                  Get.back();
                }),
            barrierDismissible: false);
      } else {
        return;
      }
    } else {
      return;
    }
  }

  static Future verifyOperation(context) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      UserProfileController.retrievProfileController(context, true);
    });
    PlanWare ware = Provider.of<PlanWare>(context, listen: false);
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    GenderList gender = GenderList(id: 2, name: "Business", selected: true);
    PlanController.retrievPlanController(context, true);
    if (ware.plans.isEmpty) {
      PlanController.retrievPlanController(context, true);
    }
    if (user.userProfileModel.gender == "Business" &&
        user.userProfileModel.verified == 0 &&
        user.userProfileModel.verification == null) {
      PageRouting.pushToPage(
          context,
          BusinessInfo(
            data: gender,
            action: "both",
          ));

      // ignore: use_build_context_synchronously
      // PageRouting.pushToPage(
      //     context, const SubscriptionPlansBusiness());
    } else if (user.userProfileModel.gender != "Business" &&
        user.userProfileModel.verified == 0 &&
        user.userProfileModel.verification == null) {
      PageRouting.pushToPage(
          context,
          BusinessVerification(
            gender: gender,
            isBusiness: false,
            action: "both",
          ));
    } else if (user.userProfileModel.gender != "Business" &&
        user.userProfileModel.verified == 2 &&
        user.userProfileModel.verification != null) {
      emitter("upload without payment");
      PageRouting.pushToPage(
          context,
          BusinessVerification(
            gender: gender,
            isBusiness: false,
            action: "upload",
          ));
      //upload without payment
    } else if (user.userProfileModel.gender == "Business" &&
        user.userProfileModel.verified == 2 &&
        user.userProfileModel.verification != null) {
      //upload without payment
      PageRouting.pushToPage(
          context,
          BusinessInfo(
            data: gender,
            action: "upload",
          ));
      emitter("upload without payment");
    } else if (user.userProfileModel.gender == "Business" &&
        user.userProfileModel.verified == 1 &&
        user.userProfileModel.activePlan == sub) {
      // payment only
      emitter("payment only");
      PageRouting.pushToPage(
          context,
          const SubscriptionPlansBusiness(
            isBusiness: true,
            isSubmiting: "pay",
          ));
    } else if (user.userProfileModel.gender != "Business" &&
        user.userProfileModel.verified == 1 &&
        user.userProfileModel.activePlan == sub) {
      // payment only
      PageRouting.pushToPage(
          context,
          const SubscriptionPlansBusiness(
            isBusiness: false,
            isSubmiting: "pay",
          ));
      emitter("payment only");
    } else {
      if (user.userProfileModel.verified == 1 &&
          user.userProfileModel.activePlan != sub) {
        Get.back();
        Get.dialog(
          verifiedDialog(
              title: "Congratulations",
              message: "Your account has been verified.",
              confirmText: "Okay",
              cancelText: "Go back",
              onPressedCancel: () {
                Get.back();
              },
              onPressed: () {
                Get.back();
              }),
        );
      } else {
        Get.back();
        Get.dialog(confirmationDialog(
            title: "Verification",
            message:
                "Your documenets are under review. This will take 48 hours or 5 working days to be confirmed.",
            confirmText: "Okay",
            cancelText: "Go back",
            onPressedCancel: () {
              Get.back();
            },
            onPressed: () {
              Get.back();
            }));
      }
    }
  }

  static String convertToCurrency(String e) {
    String newStr = e.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[0]},");
    return newStr;
  }
}
