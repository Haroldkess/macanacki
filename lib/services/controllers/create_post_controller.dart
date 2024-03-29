import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/model/comments_model.dart';
import 'package:macanacki/model/create_post_model.dart';
import 'package:macanacki/model/profile_feed_post.dart';
import 'package:macanacki/model/register_model.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/model/ui_model.dart';
import 'package:macanacki/presentation/operations.dart';
import 'package:macanacki/presentation/screens/home/profile/profile_screen.dart';
import 'package:macanacki/presentation/screens/home/tab_screen.dart';
import 'package:macanacki/presentation/widgets/float_toast.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/controllers/action_controller.dart';
import 'package:macanacki/services/controllers/feed_post_controller.dart';
import 'package:macanacki/services/controllers/login_controller.dart';
import 'package:macanacki/services/middleware/facial_ware.dart';
import 'package:macanacki/services/middleware/registeration_ware.dart';
import 'package:macanacki/services/temps/temp.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/feed_post_model.dart';
import '../../model/public_profile_model.dart';
import '../../presentation/allNavigation.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../middleware/button_ware.dart';
import '../middleware/create_post_ware.dart';
import '../middleware/feed_post_ware.dart';
import '../middleware/user_profile_ware.dart';

class CreatePostController {
  static Future<CreatePostModel> regData(
      BuildContext context, String caption) async {
    CreatePostWare pic = Provider.of<CreatePostWare>(context, listen: false);
    ButtonWare button = Provider.of<ButtonWare>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    CreatePostModel data = CreatePostModel(
        description: caption,
        published: 1,
        media: pic.file!,
        btnId: button.index,
        url: button.url);
    return data;
  }

  static Future<CreateAudioPostModel> regDataAudio(
      BuildContext context, String caption) async {
    CreatePostWare pic = Provider.of<CreatePostWare>(context, listen: false);
    ButtonWare button = Provider.of<ButtonWare>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    final CreateAudioPostModel data = CreateAudioPostModel(
        description: caption,
        published: 1,
        media: [pic.audioFile!],
        btnId: button.index,
        url: button.url,
        cover: pic.audioCoverFile);
    return data;
  }

  static Future<void> createPostController(
    BuildContext context,
    String caption,
  ) async {
    CreatePostWare ware = Provider.of<CreatePostWare>(context, listen: false);
    ButtonWare button = Provider.of<ButtonWare>(context, listen: false);
    Temp temp = Provider.of<Temp>(context, listen: false);
    FeedPostWare stream = Provider.of<FeedPostWare>(context, listen: false);

    CreatePostModel data = await regData(context, caption);
    ware.isLoading(true);

    bool isDone = await ware
        .createPostFromApi(data)
        .whenComplete(() => emitter("api function done"));

    // ignore: use_build_context_synchronously
    stream.disposeAutoScroll();
    stream.pagingController.refresh();
    //  await UserProfileController.retrievProfileController(context, false);
    // ignore: use_build_context_synchronously
    await FeedPostController.getUserPostController(context);
    //  await FeedPostController.getUserPostController(context);

    if (isDone) {
      button.addIndex(0);
      button.addUrl("");
      log("omo!!!");
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
      showToast2(context, ware.message, isError: false);
      await Future.delayed(const Duration(seconds: 2));
      // ignore: use_build_context_synchronously
      //  Get.back();
      // ignore: use_build_context_synchronously
      PageRouting.popToPage(context);
    } else {
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
      showToast2(context, ware.message, isError: true);
      //print("something went wrong");
    }
    ware.isLoading(false);
  }

  static Future<void> createAudioPostController(
    BuildContext context,
    String caption,
  ) async {
    CreatePostWare ware = Provider.of<CreatePostWare>(context, listen: false);
    ButtonWare button = Provider.of<ButtonWare>(context, listen: false);
    Temp temp = Provider.of<Temp>(context, listen: false);
    FeedPostWare stream = Provider.of<FeedPostWare>(context, listen: false);

    CreateAudioPostModel data = await regDataAudio(context, caption);
    ware.isLoadingAudio(true);

    bool isDone = await ware
        .createAudioPostFromApi(data)
        .whenComplete(() => emitter("api function done"));

    // ignore: use_build_context_synchronously
    stream.disposeAutoScroll();
    stream.pagingController.refresh();
    //  await UserProfileController.retrievProfileController(context, false);
    // ignore: use_build_context_synchronously
    await FeedPostController.getUserPostController(context);
    //  await FeedPostController.getUserPostController(context);

    if (isDone) {
      button.addIndex(0);
      button.addUrl("");
      log("omo!!!");
      ware.isLoadingAudio(false);
      // ignore: use_build_context_synchronously
      showToast2(context, ware.message, isError: false);
      await Future.delayed(const Duration(seconds: 2));
      // ignore: use_build_context_synchronously
      Get.close(2);
      // PageRouting.popToPage(context);
    } else {
      ware.isLoadingAudio(false);
      // ignore: use_build_context_synchronously
      showToast2(context, ware.message, isError: true);
      //print("something went wrong");
    }
    ware.isLoadingAudio(false);
  }

  static Future<ShareCommentsModel> regComment(String comments) async {
    ShareCommentsModel data = ShareCommentsModel(
      body: comments,
    );
    return data;
  }

  static Future<void> shareCommentController(BuildContext context,
      TextEditingController comment, int id, String page) async {
    CreatePostWare ware = Provider.of<CreatePostWare>(context, listen: false);
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    FeedPostWare profile = Provider.of<FeedPostWare>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();

    ShareCommentsModel data = ShareCommentsModel(
      body: comment.text,
    );
    ware.isLoading2(true);

    bool isDone = await ware
        .shareCommentFromApi(data, id)
        .whenComplete(() => emitter("api function done"));

    // ignore: use_build_context_synchronously
    //await FeedPostController.getUserPostController(context);

    if (isDone) {
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
          noOfLikes: sendCom.noOfLikes,
          postId: id,
          isVerified: int.tryParse(user.userProfileModel.verified.toString()));

      // ignore: use_build_context_synchronously
      Operations.commentOperation(context, true, [], finalData);
      if (page == "public") {
        PublicComment publicData = PublicComment(
            id: sendCom.id,
            username: sendCom.username,
            createdAt: sendCom.createdAt,
            updatedAt: sendCom.updatedAt,
            body: sendCom.body,
            profilePhoto: sendCom.profilePhoto,
            noOfLikes: sendCom.noOfLikes,
            postId: id,
            isVerified: sendCom.isVerified);
        user.addSingleComment(publicData, id);
      }
      if (page == "user") {
        ProfileComment userData = ProfileComment(
            id: sendCom.id,
            username: sendCom.username,
            createdAt: sendCom.createdAt,
            updatedAt: sendCom.updatedAt,
            body: sendCom.body,
            profilePhoto: sendCom.profilePhoto,
            noOfLikes: sendCom.noOfLikes,
            postId: id,
            isVerified: sendCom.isVerified);
        profile.addSingleComment(userData, id);
      }
      comment.clear();

      ware.isLoading2(false);
      // ignore: use_build_context_synchronously
      //  await ActionController.retrievAllUserLikedCommentsController(context);
      // ignore: use_build_context_synchronously
      // showToast2(context, ware.commentMessage, isError: false);
      // ignore: use_build_context_synchronously
      // showToast(context, ware.commentMessage, HexColor(primaryColor));
      // await Future.delayed(const Duration(seconds: 2));
      // ignore: use_build_context_synchronously
      // PageRouting.popToPage(context);
    } else {
      ware.isLoading2(false);
      // ignore: use_build_context_synchronously
      showToast2(context, ware.commentMessage, isError: true);
      //print("something went wrong");
    }
    ware.isLoading2(false);
  }

  static Future deletePost(BuildContext context, id) async {
    CreatePostWare ware = Provider.of<CreatePostWare>(context, listen: false);
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    FeedPostWare profile = Provider.of<FeedPostWare>(context, listen: false);

    bool isDone = await ware.deletePostFromApi(id);

    if (isDone) {
      await profile.remove(id);
      // ignore: use_build_context_synchronously
      showToast2(
        context,
        "Deleted successfully",
      );
    } else {
      // ignore: use_build_context_synchronously
      showToast2(context, "Failed to delete post", isError: true);
    }
  }

  static Future editPost(context, id, String caption) async {
    CreatePostWare ware = Provider.of<CreatePostWare>(context, listen: false);
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    FeedPostWare profile = Provider.of<FeedPostWare>(context, listen: false);

    EditPost data = EditPost(body: caption);
    ware.isLoadingEdit(true);

    bool isDone = await ware.editPostFromApi(
      data,
      id,
    );

    if (isDone) {
      showToast2(context, 'Successful', isError: false);
      await Future.delayed(const Duration(seconds: 2));
      // ignore: use_build_context_synchronously
      PageRouting.popToPage(context);
      PageRouting.popToPage(context);
      ware.isLoadingEdit(false);
    } else {
      ware.isLoadingEdit(false);
      showToast2(context, "Failed to edit post", isError: true);
    }
    ware.isLoadingEdit(false);
  }
}
