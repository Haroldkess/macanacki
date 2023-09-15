// ignore_for_file: use_build_context_synchronously

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/constants/params.dart';
import 'package:macanacki/presentation/operations.dart';
import 'package:macanacki/presentation/screens/home/Feed/people_near_you.dart';
import 'package:macanacki/presentation/screens/home/Feed/scanning.dart';
import 'package:macanacki/presentation/widgets/avatar.dart';
import 'package:macanacki/services/controllers/action_controller.dart';
import 'package:macanacki/services/controllers/feed_post_controller.dart';
import 'package:macanacki/services/controllers/mode_controller.dart';
import 'package:macanacki/services/middleware/action_ware.dart';
import 'package:macanacki/services/middleware/feed_post_ware.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import 'dart:io';
import '../../../uiproviders/screen/find_people_provider.dart';

class FeedHome extends StatefulWidget {
  const FeedHome({super.key});

  @override
  State<FeedHome> createState() => _FeedHomeState();
}

class _FeedHomeState extends State<FeedHome>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    //Operations.funcFindUser(context);

    callFeedPost(false);
  }

  @override
  Widget build(BuildContext context) {
    // FindPeopleProvider listen = context.watch<FindPeopleProvider>();
    FeedPostWare stream = context.watch<FeedPostWare>();
    // ActionWare actionStream = context.watch<ActionWare>();

    return RefreshIndicator(
        onRefresh: () => callFeedPost(true),
        backgroundColor: HexColor(primaryColor),
        color: HexColor(backgroundColor),
        child: stream.loadStatusReferesh
            ? const Center(
                child: ScanningPerimeter(
                msg: "Getting new posts for you...",
              ))
            : const PeopleHome() );
  }

  callFeedPost(bool isRefreshed) async {
    FeedPostWare provide = Provider.of<FeedPostWare>(context, listen: false);
    if (isRefreshed == false) {
      if (provide.feedPosts.isEmpty) {
        SchedulerBinding.instance.addPostFrameCallback((_) async {
        await FeedPostController.getFeedPostController(context, 1, false);
      });
        
      }
      
      SchedulerBinding.instance.addPostFrameCallback((_) {
        ActionController.retrievAllUserLikedController(context);
      });
      SchedulerBinding.instance.addPostFrameCallback((_) {
        ActionController.retrievAllUserFollowingController(context);
      });
      SchedulerBinding.instance.addPostFrameCallback((_) {
        ActionController.retrievAllUserLikedCommentsController(context);
      });
    } else {
      FeedPostWare provide = Provider.of<FeedPostWare>(context, listen: false);

      provide.isLoadingReferesh(true);
      provide.indexChange(0);
      await FeedPostController.getFeedPostController(context, 1, false);
      //   SchedulerBinding.instance.addPostFrameCallback((_) {
      ActionController.retrievAllUserLikedController(context);
      // });
      //  SchedulerBinding.instance.addPostFrameCallback((_) {
      ActionController.retrievAllUserFollowingController(context);
      //  });
      //  SchedulerBinding.instance.addPostFrameCallback((_) {
      ActionController.retrievAllUserLikedCommentsController(context);
      provide.isLoadingReferesh(false);

      setState(() {});
      //  });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
