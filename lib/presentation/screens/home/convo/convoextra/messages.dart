import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/screens/home/convo/chat/chat_screen.dart';
import 'package:makanaki/presentation/widgets/hexagon_avatar.dart';
import 'package:makanaki/presentation/widgets/text.dart';

class MessageList extends StatelessWidget {
  const MessageList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: chatUsers
          .map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: MessageWidget(messageList: e),
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
  final AppUser messageList;
  const MessageWidget({super.key, required this.messageList});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    var w = (size.width - 4 * 1) / 8;
    return InkWell(
      onTap: () =>  PageRouting.pushToPage(context,  ChatScreen(user:  messageList,)),
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width * 0.9,
        color:
            messageList.read == false ? HexColor("#F5F2F9") : Colors.transparent,
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
                            width: w + 4.0,
                            // elevation: 30.0,
                            color: HexColor(primaryColor),
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
                          HexagonAvatar(url: messageList.imageUrl, w: w),
                        ],
                      ),
                    
                      const Positioned(
                        right: 7.1,
                        top: 15.0,
                        child: Padding(
                          padding: EdgeInsets.only(right: 0, bottom: 0),
                          child: CircleAvatar(
                            radius: 5,
                            backgroundColor: Colors.green,
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
                                text: messageList.name,
                                color: messageList.read == false
                                    ? HexColor(darkColor)
                                    : HexColor("#8B8B8B"),
                                size: 20,
                                fontWeight: FontWeight.w400,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                        ),
                        SizedBox(
                            // color: Colors.amber,
                            width: width * 0.6,
                            child: AppText(
                              text: messageList.msg,
                              color: messageList.read == false
                                  ? HexColor(darkColor)
                                  : HexColor("#8B8B8B"),
                              size: 14,
                              fontWeight: FontWeight.w400,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                          width: width * 0.08,
                          //  color: Colors.amber,
                          child: AppText(
                            text: messageList.time,
                            color: messageList.read == false
                                ? HexColor(darkColor)
                                : HexColor("#8B8B8B"),
                            size: 12,
                            fontWeight: FontWeight.w400,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            align: TextAlign.right,
                          )),
                    ),
                    messageList.read
                        ? Container(
                            decoration: const BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: AppText(
                                text: " ",
                                color: HexColor(backgroundColor),
                              ),
                            ),
                          )
                        : Container(
                            decoration: const BoxDecoration(
                                color: Colors.red, shape: BoxShape.circle),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: AppText(
                                text: "3",
                                color: HexColor(backgroundColor),
                              ),
                            ),
                          )
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
