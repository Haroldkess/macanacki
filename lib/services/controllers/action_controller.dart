import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makanaki/model/reg_email_model.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/screens/onboarding/select_gender.dart';
import 'package:makanaki/presentation/screens/verification/otp_screen.dart';
import 'package:makanaki/presentation/widgets/snack_msg.dart';
import 'package:makanaki/services/middleware/action_ware.dart';
import 'package:makanaki/services/middleware/registeration_ware.dart';
import 'package:makanaki/services/temps/temp.dart';
import 'package:makanaki/services/temps/temps_id.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/widgets/debug_emitter.dart';

class ActionController {
  static Future<void> followOrUnFollowController(
      BuildContext context, String userName, int userId) async {
    ActionWare ware = Provider.of<ActionWare>(context, listen: false);

    ware.isLoading(true);
    ware.performOfflineFollow(userId);

    bool isDone = await ware
        .followOrUnFollowFromApi(userName, userId)
        .whenComplete(() => log("follow attempt done "));

    if (isDone) {
      if (ware.message == "Follow successfully") {
        ware.addFollowId(userId);
      
      } else if (ware.message == "Unfollow successfully") {
        ware.removeFollowId(userId);
    
      } else {
     
      }

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
        .whenComplete(() => log("like action attempt done "));

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
        .whenComplete(() => log("like action attempt done "));

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
        .whenComplete(() => log("everything from api and provider is done"));

    if (isDone) {
      await Future.forEach(ware.allLiked, (element) async {
        if(element.id == null){

        }else{
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
        .whenComplete(() => log("everything from api and provider is done"));

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
        .whenComplete(() => log("everything from api and provider is done"));

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
        .whenComplete(() => log("everything from api and provider is done"));

    if (isDone) {
      await Future.forEach(ware.allLikedComments, (element) async {
        await ware.addCommentId(element.id!);
      });

      ware.isLoadingAllComments(false);
    } else {
      ware.isLoadingAllComments(false);
      // ignore: use_build_context_synchronously
      //showToast(context, "An error occured", Colors.red);
    }
    ware.isLoadingAllComments(false);
  }
}
