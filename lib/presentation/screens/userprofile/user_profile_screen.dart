import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/middleware/notification_ware..dart';
import 'package:provider/provider.dart';

import '../../../services/controllers/chat_controller.dart';
import '../../../services/controllers/feed_post_controller.dart';
import '../../../services/controllers/user_profile_controller.dart';
import '../../../services/middleware/chat_ware.dart';
import '../../../services/middleware/feed_post_ware.dart';
import '../../../services/middleware/user_profile_ware.dart';
import '../../allNavigation.dart';
import '../../constants/colors.dart';
import '../../widgets/app_bar.dart';
import '../home/profile/profileextras/profile_info.dart';
import '../home/profile/profileextras/profile_post_grid.dart';
import '../notification/notification_screen.dart';
import 'extras/public_profile_info.dart';

class UsersProfile extends StatefulWidget {
  final String username;
  const UsersProfile({super.key, required this.username});

  @override
  State<UsersProfile> createState() => _UsersProfileState();
}

class _UsersProfileState extends State<UsersProfile>
    with AutomaticKeepAliveClientMixin {
  bool showMore = false;
  int seeMoreVal = 100;
  // String myUsername = "";
  TapGestureRecognizer tapGestureRecognizer = TapGestureRecognizer();
  final ScrollController _controller = ScrollController();
  late UserProfileWare stream;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    stream = context.watch<UserProfileWare>();
    NotificationWare notify = context.watch<NotificationWare>();

    return Scaffold(
      backgroundColor: HexColor("#F5F2F9"),
      body: RefreshIndicator(
        onRefresh: () async {
          getData(true);
          stream.disposeAutoScroll();
          stream.pagingController.refresh();
        },
        backgroundColor: HexColor(primaryColor),
        color: Colors.white,
        child: CustomScrollView(
          controller: _controller,
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: true,
              leading: BackButton(color: Colors.black),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // myIcon("assets/icon/macanackiicon.svg", primaryColor, 16.52,
                  //     70, false),
                  InkWell(
                    onTap: () => PageRouting.pushToPage(
                        context, const NotificationScreen()),
                    child: Stack(
                      children: [
                        SvgPicture.asset(
                          "assets/icon/notification.svg",
                        ),
                        notify.readAll
                            ? SizedBox.shrink()
                            : Positioned(
                                right: 5,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    height: 10,
                                    width: 10,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red),
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Center(
                                        child: AppText(
                                          text: notify.notifyData.length > 9
                                              ? ""
                                              : "",
                                          size: 8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),

                    // myIcon("assets/icon/notification.svg", "#828282",
                    //     19.13, 17.31, true),
                  ),
                ],
              ),
              // floating: true,
              pinned: true,
              backgroundColor: HexColor("#F5F2F9"),
              expandedHeight: 370,
              flexibleSpace: FlexibleSpaceBar(
                background: stream.loadStatus2
                    ? const PublicLoader()
                    : const PublicProfileInfo(
                        isMine: false,
                      ),
              ),
            ),
            stream.publicUserProfileModel.aboutMe != null
                ? SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: RichText(
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: showMore ? 3 : 2,
                              text: TextSpan(
                                  text: stream.publicUserProfileModel.aboutMe!
                                                  .length >=
                                              seeMoreVal &&
                                          showMore == false
                                      ? stream.publicUserProfileModel.aboutMe!
                                          .substring(0, seeMoreVal - 3)
                                      : stream.publicUserProfileModel.aboutMe!,
                                  style: GoogleFonts.leagueSpartan(
                                      textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: HexColor(darkColor).withOpacity(0.6),
                                    decorationStyle: TextDecorationStyle.solid,
                                    fontSize: 10,
                                    fontFamily: '',
                                  )),
                                  recognizer: tapGestureRecognizer
                                    ..onTap = () async {
                                      //    print("object");
                                      if (showMore) {
                                        setState(() {
                                          showMore = false;
                                        });
                                      } else {
                                        setState(() {
                                          showMore = true;
                                        });
                                      }
                                    },
                                  children: [
                                    stream.publicUserProfileModel.aboutMe!
                                                .length <
                                            seeMoreVal
                                        ? const TextSpan(text: "")
                                        : TextSpan(
                                            text:
                                                showMore ? " " : "...see more",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: HexColor(darkColor)
                                                  .withOpacity(0.6),
                                              fontWeight: FontWeight.w600,
                                            ),
                                            recognizer: tapGestureRecognizer
                                              ..onTap = () async {
                                                if (showMore) {
                                                  setState(() {
                                                    showMore = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    showMore = true;
                                                  });
                                                }
                                              },
                                          )
                                  ])),
                        )),
                      ],
                    ),
                  )
                : const SliverToBoxAdapter(
                    child: SizedBox(height: 20),
                  ),
            SliverToBoxAdapter(
              child: PublicProfilePostGrid(ware: stream),
            )
          ],
        ),
      ),
    );
  }

  Widget myIcon(String svgPath, String hexString, double height, double width,
      bool isNotification) {
    return Stack(
      children: [
        SvgPicture.asset(
          svgPath,
          height: height,
          width: width,
          color: HexColor(hexString),
        ),
        isNotification
            ? const Positioned(
                right: 2.0,
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.red,
                ),
              )
            : const SizedBox.shrink()
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      UserProfileWare stream =
          Provider.of<UserProfileWare>(context, listen: false);
      stream.disposeAutoScroll();
      stream.initializePagingController();
      getData(false);

      // Listening to scroll event
      _controller.addListener(() {
        if (_controller.position.atEdge) {
          bool isTop = _controller.position.pixels == 0;
          if (isTop) {
            print('At the top');
          } else {
            print('At the bottom');

            // Add new page
            // Add scrollController listener
            EasyDebounce.debounce(
                'myx-debouncer',
                const Duration(milliseconds: 500),
                () async => await stream.getUserPublicPostFromApi(
                    username: widget.username));

            // print(pageKey);
            // print("Inside page key");
          }
        }
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ChatWare chatWare = Provider.of<ChatWare>(context, listen: false);
      chatWare.isLoading(false);
    });

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: HexColor(backgroundColor)));
  }

  Future<void> getData(bool isRef) async {
    if (isRef) {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        UserProfileWare user = Provider.of(context, listen: false);
        await UserProfileController.retrievPublicProfileController(
            context, widget.username);

        //Re-initializing pagingController
        user.disposeAutoScroll();
        user.initializePagingController();
        user.getUserPublicPostFromApi(username: widget.username);
      });
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        UserProfileWare user = Provider.of(context, listen: false);
        if (user.publicUserProfileModel.username == null) {
          user.getUserPublicPostFromApi(username: widget.username);
          await UserProfileController.retrievPublicProfileController(
              context, widget.username);
        } else {
          if (user.publicUserProfileModel.username == widget.username) {
            return;
          } else {
            user.getUserPublicPostFromApi(username: widget.username);
            await UserProfileController.retrievPublicProfileController(
                context, widget.username);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emitter("Disposinggggggggggggggggg");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      stream.disposeAutoScroll();
    });
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
