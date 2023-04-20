import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:makanaki/presentation/allNavigation.dart';

import '../../presentation/widgets/snack_msg.dart';

class SaveMediaController {
  static Future<void> saveNetworkVideo(BuildContext context, String url) async {
    showToast2(context, "Download started. Scroll to check out more content",
        isError: false);
    String path = url;
    bool isDone = await GallerySaver.saveVideo(path).then((success) {
      return success!;
    });

    if (isDone) {
      // ignore: use_build_context_synchronously
      showToast2(context, "Video downloaded succsessfully", isError: false);
      // ignore: use_build_context_synchronously
      PageRouting.popToPage(context);
    } else {
      // ignore: use_build_context_synchronously
      showToast2(context, "Could not download video", isError: true);
      // ignore: use_build_context_synchronously
      PageRouting.popToPage(context);
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
      showToast2(context, "Image downloaded succsessfully", isError: false);
      // ignore: use_build_context_synchronously
      PageRouting.popToPage(context);
    } else {
      // ignore: use_build_context_synchronously
      showToast2(context, "Could not download Image", isError: true);
      // ignore: use_build_context_synchronously
      PageRouting.popToPage(context);
    }
  }
}
