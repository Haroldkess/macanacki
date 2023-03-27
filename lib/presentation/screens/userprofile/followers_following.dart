import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/screens/userprofile/extras/follow_list.dart';
import 'package:makanaki/presentation/screens/userprofile/extras/follow_search.dart';
import 'package:makanaki/presentation/widgets/text.dart';

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
  @override
  Widget build(BuildContext context) {
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
                children: const [
                  SizedBox(
                    height: 20,
                  ),
                  FollowSearch(),
                ],
              ),
            ),
          ),
        ),
        title: AppText(
          text: widget.title,
          color: Colors.black,
          size: 20,
          fontWeight: FontWeight.w400,
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        elevation: 0,
        backgroundColor: HexColor(backgroundColor),
        toolbarHeight: 110,
      ),
      body: const FollowFollowingList(),
    );
  }
}
