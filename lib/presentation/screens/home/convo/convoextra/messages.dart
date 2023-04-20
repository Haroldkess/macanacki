import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/constants/params.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/screens/home/convo/chat/chat_screen.dart';
import 'package:makanaki/presentation/widgets/hexagon_avatar.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/temps/temp.dart';
import 'package:provider/provider.dart';

import '../../../../../model/conversation_model.dart';
import '../../../../operations.dart';

class MessageList extends StatelessWidget {
  List<ChatData> peopleChats;
  MessageList({super.key, required this.peopleChats});

  @override
  Widget build(BuildContext context) {
    List<ChatData> peopleChat = peopleChats
      ..sort((a, b) =>
          b.conversations!.first.id!.compareTo(a.conversations!.first.id!));
    return ListBody(
      //  reverse:  true,
      children: peopleChat
          .map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: MessageWidget(people: e),
              ))
          .toList(),
    );

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
    String isOnline;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    var w = (size.width - 4 * 1) / 8;
    Temp temp = context.watch<Temp>();
    if (people.conversations!.last.sender == temp.userName) {
      isOnline = people.userTwoMode!;
    } else {
      isOnline = people.userOneMode!;
    }

    print(isOnline.toString());
    return InkWell(
      onTap: () => PageRouting.pushToPage(
          context,
          ChatScreen(
            user: people,
            chat: people.conversations!,
            mode: people.conversations!.last.sender == temp.userName
                ? people.userTwoMode!
                : people.userOneMode!,
          )),
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: people.conversations!.first.sender != temp.userName
                ? HexColor("#F5F2F9")
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          HexagonWidget.pointy(
                            width: w + 4.0 - 15,
                            elevation: 7.0,
                            color: Colors.white,
                            cornerRadius: 10.0,
                            //  padding: 10,
                            child: AspectRatio(
                              aspectRatio: HexagonType.POINTY.ratio,
                              // child: Image.asset(
                              //   'assets/tram.jpg',
                              //   fit: BoxFit.fitWidth,
                              // ),
                            ),
                          ),
                          HexagonAvatar(
                              url: people.conversations!.last.sender ==
                                      temp.userName
                                  ? people.userTwoProfilePhoto!
                                  : people.userOneProfilePhoto!,
                              w: w + 4.0 - 15),
                        ],
                      ),
                      Positioned(
                        right: 3.1,
                        top: 20.0,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 0, bottom: 0),
                          child: CircleAvatar(
                            radius: 5,
                            backgroundColor: isOnline == "online"
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
                          child: SizedBox(
                              width: width * 0.4,
                              child: AppText(
                                text: people.conversations!.last.sender ==
                                        temp.userName
                                    ? people.userTwo!
                                    : people.userOne!,
                                color: people.conversations!.isNotEmpty
                                    ? HexColor(darkColor)
                                    : HexColor("#8B8B8B"),
                                size: 17,
                                fontWeight: FontWeight.w700,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                        ),
                        SizedBox(
                            // color: Colors.amber,
                            width: width * 0.55,
                            child: AppText(
                              text: people.conversations!.first.body!,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(

                            //  color: Colors.amber,
                            child: AppText(
                          text: Operations.times(
                                  people.conversations!.first.createdAt!)
                              .toString(),
                          color: people.conversations!.isNotEmpty
                              ? HexColor(darkColor)
                              : HexColor("#8B8B8B"),
                          size: 12,
                          fontWeight: FontWeight.w400,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          align: TextAlign.right,
                        )),
                      ),
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
}
