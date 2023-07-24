import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macanacki/model/reg_email_model.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/screens/onboarding/select_gender.dart';
import 'package:macanacki/presentation/screens/verification/otp_screen.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/middleware/action_ware.dart';
import 'package:macanacki/services/middleware/registeration_ware.dart';
import 'package:macanacki/services/temps/temp.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/uiproviders/screen/comment_provider.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../middleware/create_post_ware.dart';
import '../middleware/feed_post_ware.dart';

class ActionController {
  static Future<void> followOrUnFollowController(
      BuildContext context, String userName, int userId) async {
    ActionWare ware = Provider.of<ActionWare>(context, listen: false);

    ware.isLoading(true);
    ware.performOfflineFollow(userId);

    bool isDone = await ware
        .followOrUnFollowFromApi(userName, userId)
        .whenComplete(() => emitter("follow attempt done "));

    if (isDone) {
      if (ware.message == "Follow successfully") {
        ware.addFollowId(userId);
      } else if (ware.message == "Unfollow successfully") {
        ware.removeFollowId(userId);
      } else {}

      ware.isLoading(false);
    } else {
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
      //showToast(context, "something went wrong. pls try again", Colors.red);
      //print("something went wrong");
    }
    ware.isLoading(false);
  }

  static Future<void> likeOrDislikeController(
      BuildContext context, int postId) async {
    ActionWare ware = Provider.of<ActionWare>(context, listen: false);

    ware.isLoading2(true);

    bool isDone = await ware
        .likeOrDislikeromApi(postId)
        .whenComplete(() => emitter("like action attempt done "));

    if (isDone) {
      if (ware.message2 == "Post Liked") {
        ware.addLikeId(postId);
      } else if (ware.message2 == "Post Unliked") {
        ware.removeLikeId(postId);
        ware.addTapped(false);
      } else {
        ware.addTapped(false);
      }
      ware.isLoading2(false);
    } else {
      ware.isLoading2(false);
      // ignore: use_build_context_synchronously
      //showToast(context, "something went wrong. pls try again", Colors.red);
      //print("something went wrong");
    }
    ware.isLoading2(false);
  }

  static Future<void> likeOrDislikeCommentController(
      BuildContext context, int postId, int commentId) async {
    ActionWare ware = Provider.of<ActionWare>(context, listen: false);

    ware.isLoading3(true);

    bool isDone = await ware
        .likeCommentFromApi(postId, commentId)
        .whenComplete(() => emitter("like action attempt done "));

    if (isDone) {
      ware.isLoading3(false);
    } else {
      ware.isLoading3(false);
      // ignore: use_build_context_synchronously
      //showToast(context, "something went wrong. pls try again", Colors.red);
      //print("something went wrong");
    }
    ware.isLoading3(false);
  }

  static Future<void> retrievAllUserLikedController(
      BuildContext context) async {
    ActionWare ware = Provider.of<ActionWare>(context, listen: false);

    ware.isLoadingAllLikes(true);

    bool isDone = await ware
        .getlikeFromApi()
        .whenComplete(() => emitter("everything from api and provider is done"));

    if (isDone) {
      await Future.forEach(ware.allLiked, (element) async {
        if (element.id == null) {
        } else {
          await ware.addLikeId(element.id!);
        }
      });
      //log(ware.likeIds.toString());

      ware.isLoadingAllLikes(false);
    } else {
      ware.isLoadingAllLikes(false);
      // ignore: use_build_context_synchronously
      //  showToast(context, "An error occured", Colors.red);
    }
    ware.isLoadingAllLikes(false);
  }

  static Future<void> retrievAllUserFollowingController(
      BuildContext context) async {
    ActionWare ware = Provider.of<ActionWare>(context, listen: false);

    ware.isLoadingAllFollowing(true);

    bool isDone = await ware
        .getFollowingFromApi()
        .whenComplete(() => emitter("everything from api and provider is done"));

    if (isDone) {
      await Future.forEach(ware.allFollowing, (element) async {
        await ware.addFollowId(element.id!);
      });
      ware.isLoadingAllFollowing(false);
    } else {
      ware.isLoadingAllFollowing(false);
      // ignore: use_build_context_synchronously
      //  showToast(context, "An error occured", Colors.red);
    }
    ware.isLoadingAllFollowing(false);
  }

  static Future<void> retrievAllUserFollowersController(
      BuildContext context) async {
    ActionWare ware = Provider.of<ActionWare>(context, listen: false);

    ware.isLoadingFollow(true);

    bool isDone = await ware
        .getFollowersFromApi()
        .whenComplete(() => emitter("everything from api and provider is done"));

    if (isDone) {
      // await Future.forEach(ware.allFollowing, (element) async {
      //   await ware.addFollowId(element.id!);
      // });
      ware.isLoadingFollow(false);
    } else {
      ware.isLoadingFollow(false);
      // ignore: use_build_context_synchronously
      //  showToast(context, "An error occured", Colors.red);
    }
    ware.isLoadingFollow(false);
  }

  static Future<void> retrievAllUserLikedCommentsController(
      BuildContext context) async {
    ActionWare ware = Provider.of<ActionWare>(context, listen: false);

    ware.isLoadingAllComments(true);

    bool isDone = await ware
        .getLikeCommentFromApi()
        .whenComplete(() => emitter("everything from api and provider is done"));

    if (isDone) {
      await Future.forEach(ware.allLikedComments, (element) async {
        if (element.id != null) {
          await ware.addCommentId(element.id!);
        }
      });

      ware.isLoadingAllComments(false);
    } else {
      ware.isLoadingAllComments(false);
      // ignore: use_build_context_synchronously
      //showToast(context, "An error occured", Colors.red);
    }
    ware.isLoadingAllComments(false);
  }

  static Future deleteComment(BuildContext context, id, commentId) async {
    CreatePostWare ware = Provider.of<CreatePostWare>(context, listen: false);
    StoreComment comment = Provider.of<StoreComment>(context, listen: false);
    FeedPostWare profile = Provider.of<FeedPostWare>(context, listen: false);

    bool isDone = await ware.deleteCommentFromApi(id, commentId);

    if (isDone) {
      //   await profile.remove(id);
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
}
