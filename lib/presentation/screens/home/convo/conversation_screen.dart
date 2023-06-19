import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/screens/home/convo/all_matched_screen.dart';
import 'package:makanaki/presentation/screens/home/convo/convoextra/convo_search.dart';
import 'package:makanaki/presentation/screens/home/convo/convoextra/convo_tab.dart';
import 'package:makanaki/presentation/screens/home/convo/convoextra/matches.dart';
import 'package:makanaki/presentation/screens/home/convo/convoextra/messages.dart';
import 'package:makanaki/presentation/screens/home/swipes/swipe_card_screen.dart';
import 'package:makanaki/presentation/widgets/debug_emitter.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/controllers/chat_controller.dart';
import 'package:makanaki/services/middleware/chat_ware.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';

import '../../../constants/params.dart';
import '../../../widgets/buttons.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  late Timer reloadTime;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ChatController.retrievChatController(context, false)
          .whenComplete(() => emitter("chat gotten at init"));
    });
  }

  Future reloadChat(BuildContext context) async {
    emitter("W have started the reload");
    reloadTime = Timer.periodic(const Duration(minutes: 1), (timer) async {
      await ChatController.retrievChatController(context, false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    // if (mounted) {
    //   reloadTime.cancel();
    //   //  emitter("close reload chat");
    // }
  }

  @override
  Widget build(BuildContext context) {
    ChatWare stream = context.watch<ChatWare>();
    // _memoizer.runOnce(() => reloadChat(context));
    return Scaffold(
        backgroundColor: HexColor(backgroundColor),
        appBar: AppBar(
          backgroundColor: HexColor(backgroundColor),
          automaticallyImplyLeading: false,
          elevation: 0,
          title: AppText(
            text: "Conversations",
            color: HexColor(darkColor),
            size: 24,
            fontWeight: FontWeight.w700,
          ),
          actions: [
            SvgPicture.asset("assets/icon/new.svg"),
            const SizedBox(
              width: 15,
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => ChatController.retrievChatController(context, false),
          backgroundColor: HexColor(primaryColor),
          color: HexColor(backgroundColor),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: const [
                      ConvoSearch(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppText(
                            text: "Messages",
                            fontWeight: FontWeight.w600,
                            color: HexColor(darkColor),
                            size: 17,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          // Container(
                          //   decoration: const BoxDecoration(
                          //       color: Colors.red, shape: BoxShape.circle),
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(6.0),
                          //     child: AppText(
                          //       size: 12,
                          //       text: stream
                          //           .chatList.where((element) => element.userTwo != "kelt").si
                          //           .toString(),
                          //       color: HexColor(backgroundColor),
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: stream.chatList.isEmpty ?  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              LottieBuilder.asset("assets/icon/nodata.json"),
                              AppButton(
                                  width: 0.5,
                                  height: 0.06,
                                  color: backgroundColor,
                                  text: "Start a conversation",
                                  backColor: primaryColor,
                                  curves: buttonCurves * 5,
                                  textColor: backgroundColor,
                                  onTap: () async {
                                    // await FeedPostController.getFeedPostController(
                                    //     context, 1, false);
                                    //  PageRouting.pushToPage(context, const BusinessVerification());
                                  }),
                            ],
                          ),
                        )
                      ],
                    ) :
                     MessageList(
                              peopleChats: stream.chatList,
                            ),
                    ),
              ],
            ),
          ),
        ));
  }
}
