import 'dart:io';
import 'package:advance_image_picker/models/image_object.dart';
import 'package:advance_image_picker/widgets/picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:macanacki/presentation/screens/home/profile/createpost/create_post_screen.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/presentation/widgets/video_trimmer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../services/middleware/create_post_ware.dart';
import '../services/middleware/user_profile_ware.dart';
import 'allNavigation.dart';
import 'package:image_picker/image_picker.dart' as simple_image_picker;
import 'package:path/path.dart' as path;

class OperationsExt {
  static Future pickForPost(BuildContext context) async {
    try {
      //Initialize both [CreatePost] && [UserProfile] State
      CreatePostWare picked =
          Provider.of<CreatePostWare>(context, listen: false);
      UserProfileWare user =
          Provider.of<UserProfileWare>(context, listen: false);

      final List<ImageObject>? objects = await Navigator.of(context)
          .push(PageRouteBuilder(pageBuilder: (context, animation, __) {
        return const ImagePicker(
          maxCount: 10,
        );
      }));

      if (objects == null) return;
      if ((objects.length ?? 0) < 1) return;

      //Converts result into usable file
      List<File> recievedFiles = [];
      for (ImageObject imageObject in objects) {
        recievedFiles.add(File(imageObject.modifiedPath));
      }
      //  emitter(file.first.path.toString());
      picked.addFile(recievedFiles);

      // ignore: use_build_context_synchronously
      PageRouting.pushToPage(context, const CreatePostScreen());
    } catch (e) {
      //Display error to user
      // ignore: use_build_context_synchronously
      //showToast2(context, "Oops!! ${e.toString()}", isError: true);
      return;
    }
  }

  static Future<void> pickVideoForPost(BuildContext context) async {
    if (await Permission.storage.request().isGranted) {
      final simple_image_picker.ImagePicker picker =
          simple_image_picker.ImagePicker();
      final simple_image_picker.XFile? result = await picker.pickVideo(
          source: simple_image_picker.ImageSource.gallery);
      if (result != null) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return VideoTrimmer(file: File(result.path!));
          }),
        );
      }
    }
  }
}