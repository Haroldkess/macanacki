import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:flutter/rendering.dart';
import '../../presentation/widgets/snack_msg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';

class SaveMediaController {
  static Future requestPermission() async {
    bool statuses;
    if (Platform.isAndroid) {
      final deviceInfoPlugin = DeviceInfoPlugin();
      final deviceInfo = await deviceInfoPlugin.androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;
      statuses =
          sdkInt < 29 ? await Permission.storage.request().isGranted : true;
      // statuses = await Permission.storage.request().isGranted;
    } else {
      statuses = await Permission.photosAddOnly.request().isGranted;
    }
    // _toastInfo('requestPermission result: ${statuses}');
  }

  static Future<void> saveNetworkVideo(BuildContext context, String url) async {
    // showToast2(context, "Download started. Scroll to check out more content",
    //    isError: false);
    MediaDownloadProgress.instance.addProgress(1, 100);

    Get.showSnackbar(successSnackBar("Downloading", "Video"));
    final dir = await getTemporaryDirectory();
    String savePath =
        "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4";
    String path = url;
    await requestPermission();
    await Dio().download(path, savePath,
        options: Options(
          sendTimeout: 10 * 60 * 1000,
          receiveTimeout: 10 * 60 * 1000,
        ), onReceiveProgress: (received, total) {
      MediaDownloadProgress.instance.addProgress(received, total);
    });
    final result = await SaverGallery.saveFile(
        file: savePath,
        androidExistNotSave: true,
        name: '123.mp4',
        androidRelativePath: "Movies");

    emitter(" the download link $url");
    // bool isDone = await GallerySaver.saveVideo(path).then((success) {
    //   return success!;
    // });

    if (result.isSuccess) {
      // ignore: use_build_context_synchronously
      if (context == null) {
        Fluttertoast.showToast(msg: 'Video downloaded succsessfully');
      } else {
        // ignore: use_build_context_synchronously
        try {
          showToastLater('Video downloaded successfully');
        } catch (e) {
          showToastLater('Video downloaded successfully');
          // await Fluttertoast.showToast(
          //     msg: 'Video downloaded successfully',
          //     textColor: HexColor(backgroundColor),
          //     gravity: ToastGravity.TOP,
          //     backgroundColor: HexColor(primaryColor));
        }
      }

      // ignore: use_build_context_synchronously
      // PageRouting.popToPage(context);
    } else {
      try {
        showToastLater("Could not download video");
        //   showToast2(context, "Could not download video", isError: true);
      } catch (e) {
        showToastLater('Could not download video');
        // Fluttertoast.showToast(
        //     msg: 'Could not download video',
        //     textColor: HexColor(backgroundColor),
        //     gravity: ToastGravity.TOP,
        //     backgroundColor: HexColor(primaryColor));
      }
      // ignore: use_build_context_synchronously

      // ignore: use_build_context_synchronously
      //   PageRouting.popToPage(context);
    }
  }

  static Future<void> saveNetworkImage(BuildContext context, String url) async {
    // showToast2(context, "Download started. Scroll to check out more content",
    //     isError: false);
    MediaDownloadProgress.instance.addProgress(1, 100);

    Get.showSnackbar(successSnackBar("Downloading", "Image"));
    String path = url;
    var response = await Dio().get(path,
        options: Options(
          responseType: ResponseType.bytes,
        ), onReceiveProgress: (received, total) {
      MediaDownloadProgress.instance.addProgress(received, total);
    });
    String picturesPath =
        "${path.split(".").first.isEmpty ? "name" : path.split(".").first.isEmpty}.jpg";
    await requestPermission();
    debugPrint(picturesPath);
    final result = await SaverGallery.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: picturesPath,
        androidRelativePath: "Pictures/aa/macanacki",
        androidExistNotSave: true);
    // final save = await SaverGallery.
    // bool isDone = await GallerySaver.saveImage(path).then((success) {
    //   return success!;
    // });

    if (result.isSuccess) {
      // ignore: use_build_context_synchronously

      try {
        // showToast2(context, "Image downloaded successfully", isError: false);
        showToastLater("Image downloaded successfully");
      } catch (e) {
        showToastLater('Image downloaded successfully');
        // await Fluttertoast.showToast(
        //     msg: 'Image downloaded successfully',
        //     textColor: HexColor(backgroundColor),
        //     gravity: ToastGravity.TOP,
        //     backgroundColor: HexColor(primaryColor));
      }
      // ignore: use_build_context_synchronously
      // PageRouting.popToPage(context);
    } else {
      // ignore: use_build_context_synchronously

      try {
        showToastLater("Could not download Image");
        //  showToast2(context, "Could not download Image", isError: true);
      } catch (e) {
        showToastLater('Could not download Image');
        // await Fluttertoast.showToast(
        //     msg: 'Could not download Image',
        //     textColor: HexColor(backgroundColor),
        //     gravity: ToastGravity.TOP,
        //     backgroundColor: HexColor(primaryColor));
      }
      // ignore: use_build_context_synchronously
      // PageRouting.popToPage(context);
    }
  }

  static GetSnackBar successSnackBar(
    String title,
    String message,
  ) {
    return GetSnackBar(
      messageText: ObxValue((download) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: title,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              size: 13,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                    text: message + "  ${download.value}%",
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    size: 14),
                CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.transparent,
                  child: CircularProgressIndicator.adaptive(
                    value: double.tryParse(download.value.toString())! * 0.01,
                    valueColor: AlwaysStoppedAnimation(
                      HexColor(primaryColor),
                    ),
                    backgroundColor: Colors.black,
                    //semanticsValue: "${download.value}%",
                    strokeWidth: 2,
                  ),
                )
              ],
            )
          ],
        );
      }, MediaDownloadProgress.instance.progress),
      icon: Icon(
        Icons.downloading_rounded,
        color: HexColor(primaryColor),
      ),
      borderRadius: 12.0,
      // mainButton: IconButton(icon: Icon(Icons.close, color: Colors.white,), onPressed: (){
      //   if(Get.isSnackbarOpen){
      //     Get.back();
      //   }
      // }),
      //  duration: Duration(seconds: 2),
      margin: const EdgeInsets.all(10.0),
      backgroundColor: Colors.white,
      padding: const EdgeInsets.all(10),
      animationDuration: Duration(seconds: 1),
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      reverseAnimationCurve: Curves.fastOutSlowIn,
      duration: const Duration(seconds: 3),
    );
  }
}

class MediaDownloadProgress extends GetxController {
  static MediaDownloadProgress get instance {
    return Get.find<MediaDownloadProgress>();
  }

  RxString progress = "0".obs;
  RxBool show = false.obs;

  void addProgress(int received, int total) {
    if (total != -1) {
      progress.value = (received / total * 100).toStringAsFixed(0);
    }
  }
}
