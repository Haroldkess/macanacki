import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
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
    showToast2(context, "Download started. Scroll to check out more content",
        isError: false);
    final dir = await getTemporaryDirectory();
    String savePath =
        "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4";
    String path = url;
    await requestPermission();
    await Dio().download(
      path,
      savePath,
      options: Options(
        sendTimeout: 10 * 60 * 1000,
        receiveTimeout: 10 * 60 * 1000,
      ),
      onReceiveProgress: (count, total) {
        debugPrint((count / total * 100).toStringAsFixed(0) + "%");
      },
    );
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
          showToast2(context, "Video downloaded successfully", isError: false);
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
        showToast2(context, "Could not download video", isError: true);
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
    showToast2(context, "Download started. Scroll to check out more content",
        isError: false);
    String path = url;
    var response = await Dio()
        .get(path, options: Options(responseType: ResponseType.bytes));
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
        showToast2(context, "Image downloaded successfully", isError: false);
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
        showToast2(context, "Could not download Image", isError: true);
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
}
