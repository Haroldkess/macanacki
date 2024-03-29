import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/constants/params.dart';
import 'package:macanacki/presentation/model/ui_model.dart';
import 'package:macanacki/presentation/screens/home/convo/chat/chat_screen.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/presentation/widgets/hexagon_avatar.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/controllers/chat_controller.dart';
import 'package:macanacki/services/middleware/chat_ware.dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
import 'package:macanacki/services/temps/temp.dart';
import 'package:provider/provider.dart';

import '../../../../../model/conversation_model.dart';
import '../../../../operations.dart';
import '../../../../widgets/loader.dart';

class MessageList extends StatelessWidget {
  List<ChatData> peopleChats;
  String? search;
  ScrollController scrollControl;
  MessageList(
      {super.key,
      required this.peopleChats,
      this.search,
      required this.scrollControl});

  @override
  Widget build(BuildContext context) {
    ChatWare stream = context.watch<ChatWare>();
    List<ChatData> peopleChat = stream.chatList
      ..sort((a, b) => b.conversations!.first.updatedAt!
          .compareTo(a.conversations!.first.updatedAt!));

    return StreamBuilder(
        stream: null,
        builder: (context, snapshot) {
          List<ChatData>? filtered = peopleChat
              .where((element) =>
                  element.userOne!.contains(stream.searchName.toLowerCase()) ||
                  element.userTwo!.contains(stream.searchName.toLowerCase()))
              .toList();

          return Column(
            //  reverse:  true,
            children: filtered
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: MessageWidget(
                        people: e,
                        scrollControl: scrollControl,
                      ),
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

class MessageWidget extends StatefulWidget {
  ChatData people;
  ScrollController scrollControl;
  MessageWidget({super.key, required this.people, required this.scrollControl});

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    ChatWare streams = context.watch<ChatWare>();
    // ChatData people = streams.chatList
    //     .where((element) => element.id == peopleData.id)
    //     .toList()
    //     .first;
    String isOnline;
    int verify;
    dynamic id;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    var w = (size.width - 4 * 1) / 8;
    Temp temp = context.watch<Temp>();
    UserProfileWare profie = context.watch<UserProfileWare>();

    if (widget.people.conversations!.last.sender ==
        profie.userProfileModel.username) {
      isOnline = widget.people.userTwoMode ?? "";
      verify = widget.people.userTwoVerify!;
      id = widget.people.userTwoId!;
    } else {
      isOnline = widget.people.userOneMode ?? "";
      verify = widget.people.userOneVerify!;
      id = widget.people.userOneId!;
    }

    return InkWell(
      onTap: () async {
        ChatWare ware = Provider.of<ChatWare>(context, listen: false);
        ware.chatPageChange(0);
        ChatController.readAll(
            context,
            widget.people.conversations!.last.sender == temp.userName
                ? widget.people.userTwoId!
                : widget.people.userOneId!);
        final data = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                    user: widget.people,
                    chat: widget.people.conversations!,
                    mode: widget.people.conversations!.last.sender ==
                            temp.userName
                        ? widget.people.userTwoMode ?? "offline"
                        : widget.people.userOneMode ?? "offline",
                    isHome: true,
                    verified: verify,
                  )),
        );

        // ignore: use_build_context_synchronously
        await ChatController.addToList(context, data);
        try {
          ware.chatPageChange(1);
          ware.addChatName("");
          ware.addHoldingChats();
          if (ware.isTexted == true) {
            ware.getChatFromApi(false, 1, false);
            // if (widget.scrollControl.hasClients) {
            //   widget.scrollControl
            //       .jumpTo(widget.scrollControl.position.maxScrollExtent + 300);
            // }
          } else {}
          ware.texted(false);
        } catch (e) {
          emitter(e.toString());
        }
        //  emitter("hello ${data.first.conversations.first.body}");

        // ignore: use_build_context_synchronously
        //  ChatController.retreiveUnread(context);
      },
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          dp(
                              context,
                              widget.people.conversations!.last.sender ==
                                      temp.userName
                                  ? widget.people.userTwoProfilePhoto!
                                  : widget.people.userOneProfilePhoto!),
                          Positioned(
                            right: 10.1,
                            top: 5.0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 0, bottom: 0),
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
                                        widget.people.conversations!.last
                                                    .sender ==
                                                temp.userName
                                            ? widget.people.userTwo!
                                            : widget.people.userOne!,
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: widget
                                                        .people
                                                        .conversations!
                                                        .isNotEmpty
                                                    ? textWhite
                                                    : HexColor("#8B8B8B"),
                                                decorationStyle:
                                                    TextDecorationStyle.solid,
                                                fontSize: 16)),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                  verify == 0 || verify == null
                                      ? const SizedBox.shrink()
                                      : verify == 1
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3),
                                              child: SvgPicture.asset(
                                                "assets/icon/badge.svg",
                                                height: 10,
                                                width: 10,
                                              ),
                                            )
                                          : const SizedBox.shrink()
                                ],
                              ),
                            ),
                            SizedBox(
                                // color: Colors.amber,
                                width: width * 0.4,
                                child: AppText(
                                  text: streams.chatList
                                      .where((element) =>
                                          element.id == widget.people.id)
                                      .first
                                      .conversations!
                                      .first
                                      .body!,
                                  color: widget.people.conversations!.isNotEmpty
                                      ? textPrimary
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
                                  text: Operations.times(widget.people
                                          .conversations!.first.createdAt!)
                                      .toString(),
                                  color: widget.people.conversations!.isNotEmpty
                                      ? textPrimary
                                      : HexColor("#8B8B8B"),
                                  size: 10,
                                  fontWeight: FontWeight.w400,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  align: TextAlign.right,
                                )),
                          ),

                          widget.people.conversations!.first.sender !=
                                      temp.userName &&
                                  streams.unreadMsgs
                                      .where((element) =>
                                          element.senderId ==
                                          widget.people.conversations!.first
                                              .senderId)
                                      .toList()
                                      .isNotEmpty
                              ? Container(
                                  width: 23,
                                  height: 16,
                                  decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: AppText(
                                      size: 8,
                                      text: streams.unreadMsgs
                                                  .where((element) =>
                                                      element.senderId ==
                                                      widget
                                                          .people
                                                          .conversations!
                                                          .first
                                                          .senderId)
                                                  .first
                                                  .totalUnread! >
                                              99
                                          ? "99+"
                                          : streams.unreadMsgs
                                              .where((element) =>
                                                  element.senderId ==
                                                  widget.people.conversations!
                                                      .first.senderId)
                                              .first
                                              .totalUnread!
                                              .toString(),
                                      color: textWhite,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 23,
                                  height: 16,
                                )

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
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Divider(
                  color: backgroundSecondary,
                  thickness: 1,
                  //height: 2,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget dp(BuildContext context, String url) {
    var w = 55.0;
    return Stack(
      children: [
        HexagonWidget.pointy(
          width: w,
          elevation: 2.0,
          color: backgroundSecondary,
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
                      Center(child: Loader(color: textPrimary)),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    color: textPrimary,
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
