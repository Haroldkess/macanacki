import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/constants/params.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/screens/home/convo/chat/chat_screen.dart';
import 'package:makanaki/presentation/widgets/hexagon_avatar.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/middleware/chat_ware.dart';
import 'package:makanaki/services/temps/temp.dart';
import 'package:provider/provider.dart';

import '../../../../../model/conversation_model.dart';
import '../../../../operations.dart';
import '../../../../widgets/loader.dart';

class MessageList extends StatelessWidget {
  List<ChatData> peopleChats;
  String? search;
  MessageList({super.key, required this.peopleChats, this.search});

  @override
  Widget build(BuildContext context) {
    ChatWare stream = context.watch<ChatWare>();
    List<ChatData> peopleChat = stream.chatList
      ..sort((a, b) =>
          b.conversations!.first.id!.compareTo(a.conversations!.first.id!));
    return StreamBuilder(
        stream: null,
        builder: (context, snapshot) {
          List<ChatData>? filtered = peopleChat
              .where((element) =>
                  element.userOne!.contains(stream.searchName.toLowerCase()) ||
                  element.userTwo!.contains(stream.searchName.toLowerCase()))
              .toList();

          return ListBody(
            //  reverse:  true,
            children: filtered
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: MessageWidget(people: e),
                    ))
                .toList(),
          );
        });

    // ListView.builder(
    //     itemCount: chatUsers.length,
    //     scrollDirection: Axis.vertical,
    //     itemBuilder: (context, index) {
    //       AppUser messages = chatUsers[index];
    //       return Padding(
    //         padding: const EdgeInsets.symmetric(vertical: 8.0),
    //         child: MessageWidget(messageList: messages),
    //       );
    //     });
  }
}

class MessageWidget extends StatelessWidget {
  ChatData people;
  MessageWidget({super.key, required this.people});

  @override
  Widget build(BuildContext context) {
    ChatWare streams = context.watch<ChatWare>();
    String isOnline;
    int verify;
    dynamic id;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    var w = (size.width - 4 * 1) / 8;
    Temp temp = context.watch<Temp>();

    if (people.conversations!.last.sender == temp.userName) {
      isOnline = people.userTwoMode ?? "";
      verify = people.userTwoVerify!;
      id = people.userTwoId!;
    } else {
      isOnline = people.userOneMode ?? "";
      verify = people.userOneVerify!;
      id = people.userOneId!;
    }

    return InkWell(
      onTap: () => PageRouting.pushToPage(
          context,
          ChatScreen(
            user: people,
            chat: people.conversations!,
            mode: people.conversations!.last.sender == temp.userName
                ? people.userTwoMode ?? "offline"
                : people.userOneMode ?? "offline",
            isHome: true,
            verified: verify,
          )),
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      dp(
                          context,
                          people.conversations!.last.sender == temp.userName
                              ? people.userTwoProfilePhoto!
                              : people.userOneProfilePhoto!),
                      Positioned(
                        right: 10.1,
                        top: 13.0,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 0, bottom: 0),
                          child: CircleAvatar(
                            radius: 5,
                            backgroundColor: streams.allSocketUsers
                                    .where((element) =>
                                        element.userId.toString() ==
                                        id.toString())
                                    .toList()
                                    .isNotEmpty
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6, left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Container(
                                  constraints: BoxConstraints(
                                    maxWidth: width * 0.4,
                                  ),
                                  //  color: Colors.amber,
                                  child: Text(
                                    people.conversations!.last.sender ==
                                            temp.userName
                                        ? people.userTwo!
                                        : people.userOne!,
                                    style: GoogleFonts.spartan(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color:
                                                people.conversations!.isNotEmpty
                                                    ? HexColor(darkColor)
                                                    : HexColor("#8B8B8B"),
                                            decorationStyle:
                                                TextDecorationStyle.solid,
                                            fontSize: 13)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              verify == 0 || verify == null
                                  ? const SizedBox.shrink()
                                  : Padding(
                                      padding: const EdgeInsets.only(left: 3),
                                      child: SvgPicture.asset(
                                        "assets/icon/badge.svg",
                                        height: 10,
                                        width: 10,
                                      ),
                                    )
                            ],
                          ),
                        ),
                        SizedBox(
                            // color: Colors.amber,
                            width: width * 0.4,
                            child: AppText(
                              text: streams.chatList
                                  .where((element) => element.id == people.id)
                                  .first
                                  .conversations!
                                  .first
                                  .body!,
                              color: people.conversations!.isNotEmpty
                                  ? HexColor(darkColor)
                                  : HexColor("#8B8B8B"),
                              size: 12,
                              fontWeight: FontWeight.w500,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ],
                    ),
                  )
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                            constraints: BoxConstraints(maxWidth: 70),

                            //  color: Colors.amber,
                            child: AppText(
                              text: Operations.times(
                                      people.conversations!.first.createdAt!)
                                  .toString(),
                              color: people.conversations!.isNotEmpty
                                  ? HexColor(darkColor)
                                  : HexColor("#8B8B8B"),
                              size: 10,
                              fontWeight: FontWeight.w400,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              align: TextAlign.right,
                            )),
                      ),

                      people.conversations!.first.sender != temp.userName &&
                              streams.unreadMsgs
                                  .where((element) =>
                                      element.senderId ==
                                      people.conversations!.first.senderId)
                                  .toList()
                                  .isNotEmpty
                          ? Container(
                              width: 25,
                              height: 19,
                              decoration: const BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle),
                              child: Center(
                                child: AppText(
                                  size: 8,
                                  text: streams.unreadMsgs
                                              .where((element) =>
                                                  element.senderId ==
                                                  people.conversations!.first
                                                      .senderId)
                                              .first
                                              .totalUnread! >
                                          99
                                      ? "99+"
                                      : streams.unreadMsgs
                                          .where((element) =>
                                              element.senderId ==
                                              people.conversations!.first
                                                  .senderId)
                                          .first
                                          .totalUnread!
                                          .toString(),
                                  color: HexColor(backgroundColor),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          : const SizedBox.shrink()

                      // people.conversations!.isEmpty
                      //     ? Container(
                      //         decoration: const BoxDecoration(
                      //             color: Colors.transparent,
                      //             shape: BoxShape.circle),
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(5.0),
                      //           child: AppText(
                      //             text: " ",
                      //             color: HexColor(backgroundColor),
                      //           ),
                      //         ),
                      //       )
                      //     : people.conversations!.first.sender == "kelt"
                      //         ? const SizedBox.shrink()
                      //         : Container(
                      //             decoration: const BoxDecoration(
                      //                 color: Colors.red,
                      //                 shape: BoxShape.circle),
                      //             child: Padding(
                      //               padding: const EdgeInsets.all(5.0),
                      //               child: AppText(
                      //                 size: 12,
                      //                 text: people.conversations!
                      //                     .where((element) =>
                      //                         element.sender != people.userTwo)
                      //                     .length
                      //                     .toString(),
                      //                 color: HexColor(backgroundColor),
                      //               ),
                      //             ),
                      //           )
                      // SizedBox(
                      //     // color: Colors.amber,
                      //     width: width * 0.6,
                      //     child: AppText(
                      //       text: messageList.msg,
                      //       color: messageList.read == false
                      //           ? HexColor(darkColor)
                      //           : HexColor("#8B8B8B"),
                      //       size: 14,
                      //       fontWeight: FontWeight.w400,
                      //       maxLines: 2,
                      //       overflow: TextOverflow.ellipsis,
                      //     )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget dp(BuildContext context, String url) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    var w = 55.0;
    return Stack(
      children: [
        HexagonWidget.pointy(
          width: w,
          elevation: 2.0,
          color: Colors.white,
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
          elevation: 0.0,
          color: HexColor("#5F5F5F"),
          padding: 2,
          cornerRadius: 20.0,
          child: AspectRatio(
              aspectRatio: HexagonType.POINTY.ratio,
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: url,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                          child: Loader(
                    color: HexColor(primaryColor),
                  )),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    color: HexColor(primaryColor),
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
