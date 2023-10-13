import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/home/convo/all_matched_screen.dart';
import 'package:macanacki/presentation/screens/home/convo/convoextra/convo_search.dart';
import 'package:macanacki/presentation/screens/home/convo/convoextra/convo_tab.dart';
import 'package:macanacki/presentation/screens/home/convo/convoextra/matches.dart';
import 'package:macanacki/presentation/screens/home/convo/convoextra/messages.dart';
import 'package:macanacki/presentation/screens/home/swipes/swipe_card_screen.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/controllers/chat_controller.dart';
import 'package:macanacki/services/middleware/chat_ware.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

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
  TextEditingController searchChat = TextEditingController();
  ScrollController scrollControl = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ChatWare stream = Provider.of<ChatWare>(context, listen: false);
      setState(() {
        searchChat = TextEditingController(text: stream.searchName);
      });
    });
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ChatWare stream = Provider.of<ChatWare>(context, listen: false);
      searchChat = TextEditingController(text: stream.searchName);
      ChatController.retrievChatController(context, false, false)
          .whenComplete(() => emitter("chat gotten at init"));
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

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await ChatController.retrievChatController(context, true, false);
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    ChatWare provide = Provider.of<ChatWare>(context, listen: false);

    int pageNum = int.tryParse(
        provide.initialConverstation!.currentPage!)!; // api current  page num
    int maxPages = provide.initialConverstation!.lastPageNo!;
    if (pageNum >= maxPages) {
      await Future.delayed(Duration(milliseconds: 1000));
      if (mounted) setState(() {});
      _refreshController.loadComplete();
    } else {
      emitter("$pageNum  $maxPages");
      //  emitter("PAGINTATING");
      // if (provide.loadStatus) {
      //   return;
      // }
      //   await Future.delayed(Duration(milliseconds: 1000));
      await ChatController.retrievChatController(
              context, false, true, pageNum + 1)
          .whenComplete(() => emitter("paginated"));
      if (scrollControl.hasClients) {
        scrollControl.jumpTo(scrollControl.position.maxScrollExtent);
      }
      if (mounted) {
        setState(() {
          scrollControl.jumpTo(scrollControl.position.maxScrollExtent);
        });
      }
      _refreshController.loadComplete();
    }
    // monitor network fetch

    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
  }

  @override
  Widget build(BuildContext context) {
    ChatWare stream = context.watch<ChatWare>();
    // _memoizer.runOnce(() => reloadChat(context));
    // if (stream.chatPage != 0) {
    //   ChatController.changeChatPage(context, 0);
    // }
    // emitter("rebuilt");
    return SafeArea(
      child: Scaffold(
          backgroundColor: HexColor(backgroundColor),
          appBar: AppBar(
            backgroundColor: HexColor(backgroundColor),
            //  automaticallyImplyLeading: false,
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
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (_) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SmartRefresher(
              // onRefresh: () =>
              //     ChatController.retrievChatController(context, true),
              // backgroundColor: HexColor(primaryColor),
              // color: HexColor(backgroundColor),
              enablePullDown: true,
              enablePullUp: true,

              header: WaterDropHeader(
                waterDropColor: HexColor(primaryColor),
                refresh: CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.transparent,
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color?>(HexColor(primaryColor)),
                  ),
                ),
              ),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus? mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text("pull up load");
                  } else if (mode == LoadStatus.loading) {
                    body = CupertinoActivityIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = const Text("Load Failed!Click retry!");
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text("release to load more");
                  } else {
                    body = Text("No more Data");
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: SingleChildScrollView(
                //   physics: const AlwaysScrollableScrollPhysics(),
                controller: scrollControl,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          ConvoSearch(
                            controller: searchChat,
                          ),
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
                    stream.loadStatus
                        ? MessageLoader()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: stream.chatList.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Column(
                                          children: [
                                            LottieBuilder.asset(
                                                "assets/icon/nodata.json"),
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
                                  )
                                : MessageList(
                                    peopleChats: stream.chatList,
                                    search: searchChat.text,
                                    scrollControl: scrollControl,
                                  ),
                          ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class MessageLoader extends StatelessWidget {
  const MessageLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: List.generate(
          5,
          (index) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                child: Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Shimmer.fromColors(
                            baseColor: baseColor,
                            highlightColor: highlightColor,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Shimmer.fromColors(
                                baseColor: baseColor,
                                highlightColor: highlightColor,
                                child: Container(
                                  height: 20,
                                  width: 100,
                                  color: Colors.white,
                                  child: Center(
                                    child: AppText(text: ""),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Shimmer.fromColors(
                                baseColor: baseColor,
                                highlightColor: highlightColor,
                                child: Container(
                                  height: 20,
                                  width: 50,
                                  color: Colors.white,
                                  child: Center(
                                    child: AppText(text: ""),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Shimmer.fromColors(
                            baseColor: baseColor,
                            highlightColor: highlightColor,
                            child: Container(
                              height: 20,
                              width: 30,
                              color: Colors.white,
                              child: Center(
                                child: AppText(text: ""),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )),
    );
  }
}
