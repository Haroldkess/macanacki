import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';

import '../../presentation/widgets/snack_msg.dart';

class SaveMediaController {
  static Future<void> saveNetworkVideo(BuildContext context, String url) async {
    showToast2(context, "Download started. Scroll to check out more content",
        isError: false);
    String path = url;
    emitter(" the download link $url");
    bool isDone = await GallerySaver.saveVideo(path).then((success) {
      return success!;
    });

    if (isDone) {
      // ignore: use_build_context_synchronously
      if (context == null) {
        Fluttertoast.showToast(msg: 'Video downloaded succsessfully');
      } else {
        // ignore: use_build_context_synchronously
        try {
          showToast2(context, "Video downloaded successfully", isError: false);
        } catch (e) {
          await Fluttertoast.showToast(
              msg: 'Video downloaded successfully',
              textColor: HexColor(backgroundColor),
              gravity: ToastGravity.TOP,
              backgroundColor: HexColor(primaryColor));
        }
      }

      // ignore: use_build_context_synchronously
      // PageRouting.popToPage(context);
    } else {
      await Fluttertoast.showToast(
          msg: 'Could not download video',
          textColor: HexColor(backgroundColor),
          gravity: ToastGravity.TOP,
          backgroundColor: HexColor(primaryColor));
      try {
        showToast2(context, "Could not download video", isError: true);
      } catch (e) {
        Fluttertoast.showToast(
            msg: 'Could not download video',
            textColor: HexColor(backgroundColor),
            gravity: ToastGravity.TOP,
            backgroundColor: HexColor(primaryColor));
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
    bool isDone = await GallerySaver.saveImage(path).then((success) {
      return success!;
    });

    if (isDone) {
      // ignore: use_build_context_synchronously

      try {
        showToast2(context, "Image downloaded successfully", isError: false);
      } catch (e) {
        await Fluttertoast.showToast(
            msg: 'Image downloaded successfully',
            textColor: HexColor(backgroundColor),
            gravity: ToastGravity.TOP,
            backgroundColor: HexColor(primaryColor));
      }
      // ignore: use_build_context_synchronously
      // PageRouting.popToPage(context);
    } else {
      // ignore: use_build_context_synchronously

      try {
        showToast2(context, "Could not download Image", isError: true);
      } catch (e) {
        await Fluttertoast.showToast(
            msg: 'Could not download Image',
            textColor: HexColor(backgroundColor),
            gravity: ToastGravity.TOP,
            backgroundColor: HexColor(primaryColor));
      }
      // ignore: use_build_context_synchronously
      // PageRouting.popToPage(context);
    }
  }
}
