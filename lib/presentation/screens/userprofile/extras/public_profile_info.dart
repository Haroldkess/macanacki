import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/constants/params.dart';
import 'package:macanacki/presentation/screens/home/profile/profileextras/not_mine_buttons.dart';
import 'package:macanacki/presentation/screens/home/profile/profileextras/profile_action_buttons.dart';
import 'package:macanacki/presentation/screens/home/profile/profileextras/profile_followers.dart';
import 'package:macanacki/presentation/screens/home/profile/profileextras/profile_image_name.dart';
import 'package:macanacki/presentation/screens/userprofile/extras/public_profile_followers.dart';
import 'package:macanacki/presentation/screens/userprofile/extras/public_profile_image_name.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../services/controllers/user_profile_controller.dart';
import '../../../../../services/middleware/user_profile_ware.dart';
import '../../../../model/public_profile_model.dart';
import '../../../../services/controllers/chat_controller.dart';

class PublicProfileInfo extends StatefulWidget {
  final bool isMine;
  const PublicProfileInfo({super.key, required this.isMine});

  @override
  State<PublicProfileInfo> createState() => _PublicProfileInfoState();
}

class _PublicProfileInfoState extends State<PublicProfileInfo> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      //  height: height / 2,
      width: width,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
          color: HexColor(backgroundColor),
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.elliptical(250, 200),
              bottomRight: Radius.elliptical(250, 200))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          SizedBox(
            height: 50,
          ),
          PublicProfileImageAndName(),
          PublicProfileFollowersStatistics(),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: UserProfileActions(),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   ChatController.retrievChatController(context, false);
    // });
  }
}

class PublicLoader extends StatelessWidget {
  const PublicLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: HexColor(backgroundColor),
      highlightColor: backgroundSecondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          SizedBox(
            height: 50,
          ),
          LoaderImageAndName(),
          SizedBox(
            height: 20,
          ),
          PublicLoaderFollowers(),
          UserProfileActions()
        ],
      ),
    );
  }
}

class PublicProfileInfoExtra extends StatefulWidget {
  final bool isMine;
  const PublicProfileInfoExtra({super.key, required this.isMine});

  @override
  State<PublicProfileInfoExtra> createState() => _PublicProfileInfoExtraState();
}

class _PublicProfileInfoExtraState extends State<PublicProfileInfoExtra> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      //  height: height / 2,
      width: width,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
          color: HexColor(backgroundColor),
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.elliptical(250, 200),
              bottomRight: Radius.elliptical(250, 200))),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 50,
          ),
          PublicProfileImageAndNameExtra(),
          PublicProfileFollowersStatisticsExtra(),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: UserProfileActionsExtra(),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   ChatController.retrievChatController(context, false);
    // });
  }
}

class PublicProfileInfoTest extends StatefulWidget {
  final bool isMine;
  PublicUserData stream;
  PublicProfileInfoTest(
      {super.key, required this.isMine, required this.stream});

  @override
  State<PublicProfileInfoTest> createState() => _PublicProfileInfoTestState();
}

class _PublicProfileInfoTestState extends State<PublicProfileInfoTest> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.grey.shade900,
      child: Container(
        //  height: height / 2,
        width: width,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
            color: HexColor(backgroundColor),
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.elliptical(250, 200),
                bottomRight: Radius.elliptical(250, 200))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 50,
            ),
            PublicProfileImageAndNameTest(
              stream: widget.stream,
            ),
            PublicProfileFollowersStatisticsTest(
              stream: widget.stream,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: UserProfileActionsTest(
                data: widget.stream,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   ChatController.retrievChatController(context, false);
    // });
  }
}

class LoaderImageAndName extends StatelessWidget {
  const LoaderImageAndName({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    var w = (size.width - 4 * 1) / 3;
    UserProfileWare stream = context.watch<UserProfileWare>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            HexagonWidget.pointy(
              width: w,
              elevation: 10.0,
              color: textPrimary,
              cornerRadius: 20.0,
              child: AspectRatio(
                aspectRatio: HexagonType.POINTY.ratio,
                // child: Image.asset(
                //   'assets/tram.jpg',
                //   fit: BoxFit.fitWidth,
                // ),
              ),
            ),
            HexagonWidget.pointy(
              width: w,
              elevation: 10.0,
              color: HexColor(backgroundColor),
              //color: HexColor("#5F5F5F"),
              padding: 10,
              cornerRadius: 20.0,
              child: AspectRatio(
                  aspectRatio: HexagonType.POINTY.ratio,
                  child: Center(child: Image.network(url))),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          color: stream.loadStatus ? baseColor : Colors.transparent,
          width:
              stream.loadStatus ? 200 : MediaQuery.of(context).size.width * 0.7,
          height: stream.loadStatus ? 30 : null,
          child: stream.loadStatus
              ? const SizedBox.shrink()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            text: "      , ",
                            style: GoogleFonts.leagueSpartan(
                              color: HexColor(darkColor),
                              fontSize: 24,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: " ",
                                style: GoogleFonts.leagueSpartan(
                                    color: HexColor("#C0C0C0"), fontSize: 24),
                              )
                            ])),
                    Image.asset(
                      "assets/pic/verified.png",
                      height: 27,
                      width: 27,
                    )
                  ],
                ),
        )
      ],
    );
  }
}
