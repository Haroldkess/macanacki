import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/home/profile/profileextras/follow_list.dart';
import 'package:macanacki/presentation/screens/userprofile/extras/follow_search.dart';
import 'package:macanacki/presentation/widgets/loader.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/controllers/action_controller.dart';
import 'package:macanacki/services/middleware/action_ware.dart';
import 'package:provider/provider.dart';
import 'package:scroll_edge_listener/scroll_edge_listener.dart';

import '../../../uiproviders/screen/find_people_provider.dart';

class FollowersAndFollowingScreen extends StatefulWidget {
  final String title;
  final bool isFollowing;

  const FollowersAndFollowingScreen(
      {super.key, required this.title, required this.isFollowing});

  @override
  State<FollowersAndFollowingScreen> createState() =>
      _FollowersAndFollowingScreenState();
}

class _FollowersAndFollowingScreenState
    extends State<FollowersAndFollowingScreen> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    // if (widget.isFollowing) {
    //   SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
    //     FindPeopleProvider search =
    //         Provider.of<FindPeopleProvider>(context, listen: false);
    //     search.search("");
    //     await ActionController.retrievAllUserFollowingController(context);
    //   });
    // } else {
    //   SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
    //     FindPeopleProvider search =
    //         Provider.of<FindPeopleProvider>(context, listen: false);
    //     search.search("");
    //     await ActionController.retrievAllUserFollowersController(context);
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    ActionWare stream = context.watch<ActionWare>();
    return Scaffold(
      backgroundColor: HexColor("#F5F2F9"),
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size(0, 20),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 15, right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  //FOLLOW SEARCH
                  FollowSearch(
                      controller: controller,
                      onChanged: (val) {
                        stream.updateRequestMode("search");
                        stream.updateSearch(val);
                        if (widget.isFollowing == 'Following') {
                          stream.getFollowingFromApi();
                        } else {
                          stream.getFollowersFromApi();
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
        title: AppText(
          text: widget.isFollowing
              ? "Following ${widget.title}"
              : "${widget.title} Followers",
          color: Colors.black,
          size: 14,
          fontWeight: FontWeight.w700,
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        elevation: 0,
        backgroundColor: HexColor(backgroundColor),
        toolbarHeight: 110,
      ),
      body: stream.loadStatusAllFollowing || stream.loadStatusFollower
          ? Center(child: Loader(color: HexColor(primaryColor)))
          : FollowFollowingList(
              ware: stream,
              what: widget.isFollowing ? "Following" : "Followers",
            ),
    );
  }
}
