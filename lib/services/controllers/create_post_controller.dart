import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/model/comments_model.dart';
import 'package:makanaki/model/create_post_model.dart';
import 'package:makanaki/model/register_model.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/operations.dart';
import 'package:makanaki/presentation/screens/home/tab_screen.dart';
import 'package:makanaki/presentation/widgets/float_toast.dart';
import 'package:makanaki/presentation/widgets/snack_msg.dart';
import 'package:makanaki/services/controllers/feed_post_controller.dart';
import 'package:makanaki/services/controllers/login_controller.dart';
import 'package:makanaki/services/middleware/facial_ware.dart';
import 'package:makanaki/services/middleware/registeration_ware.dart';
import 'package:makanaki/services/temps/temp.dart';
import 'package:makanaki/services/temps/temps_id.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/feed_post_model.dart';
import '../../presentation/allNavigation.dart';
import '../middleware/create_post_ware.dart';

class CreatePostController {
  static Future<CreatePostModel> regData(
      BuildContext context, String caption) async {
    CreatePostWare pic = Provider.of<CreatePostWare>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    CreatePostModel data = CreatePostModel(
      description: caption,
      published: 1,
      media: pic.file,
    );
    return data;
  }

  static Future<void> createPostController(
      BuildContext context, String caption) async {
    CreatePostWare ware = Provider.of<CreatePostWare>(context, listen: false);
    Temp temp = Provider.of<Temp>(context, listen: false);

    CreatePostModel data = await regData(context, caption);
    ware.isLoading(true);

    bool isDone = await ware
        .createPostFromApi(data)
        .whenComplete(() => log("api function done"));

    // ignore: use_build_context_synchronously
    await FeedPostController.getUserPostController(context);

    if (isDone) {
      log("omo!!!");
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
      showToast(context, ware.message, HexColor(primaryColor));
      await Future.delayed(const Duration(seconds: 2));
      // ignore: use_build_context_synchronously
      PageRouting.popToPage(context);
    } else {
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
      showToast(context, ware.message, Colors.red);
      //print("something went wrong");
    }
  }

  static Future<ShareCommentsModel> regComment(String comments) async {
    ShareCommentsModel data = ShareCommentsModel(
      body: comments,
    );
    return data;
  }

  static Future<void> shareCommentController(
      BuildContext context, TextEditingController comment, int id) async {
    CreatePostWare ware = Provider.of<CreatePostWare>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();

    ShareCommentsModel data = ShareCommentsModel(
      body: comment.text,
    );
    ware.isLoading2(true);

    bool isDone = await ware
        .shareCommentFromApi(data, id)
        .whenComplete(() => log("api function done"));

    final CommentInfo sendCom = ware.comments.comments!
        .where((element) => pref.getString(userNameKey) == element.username)
        .last;

    Comment finalData = Comment(
        id: sendCom.id,
        username: sendCom.username,
        createdAt: sendCom.createdAt,
        updatedAt: sendCom.updatedAt,
        body: sendCom.body,
        profilePhoto: sendCom.profilePhoto,
        noOfLikes: sendCom.noOfLikes);

    // ignore: use_build_context_synchronously
    //await FeedPostController.getUserPostController(context);

    if (isDone) {
      // ignore: use_build_context_synchronously
      Operations.commentOperation(context, true, [], finalData);
      comment.clear();
      log("omo!!!");
      ware.isLoading2(false);
      floatToast(ware.commentMessage, HexColor(primaryColor));
      // ignore: use_build_context_synchronously
      // showToast(context, ware.commentMessage, HexColor(primaryColor));
      await Future.delayed(const Duration(seconds: 2));
      // ignore: use_build_context_synchronously
      // PageRouting.popToPage(context);
    } else {
      ware.isLoading2(false);
      // ignore: use_build_context_synchronously
      floatToast(ware.commentMessage, Colors.red.shade300);
      //print("something went wrong");
    }
  }
}
