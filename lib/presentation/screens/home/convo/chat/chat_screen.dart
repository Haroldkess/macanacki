import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/screens/home/convo/chat/chatextra/chat_field.dart';
import 'package:makanaki/presentation/screens/home/convo/chat/chatextra/chat_grid.dart';
import 'package:makanaki/presentation/screens/home/convo/chat/chatextra/option_menu.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/controllers/chat_controller.dart';
import 'package:makanaki/services/middleware/user_profile_ware.dart';
import 'package:makanaki/services/temps/temp.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../model/conversation_model.dart';
import '../../../../../services/controllers/mode_controller.dart';
import '../../../../../services/middleware/chat_ware.dart';
import '../../../../../services/temps/temps_id.dart';
import '../../../../allNavigation.dart';
import '../../../../constants/colors.dart';
import '../../../../widgets/hexagon_avatar.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import '../../../userprofile/user_profile_screen.dart';
import '../../profile/profile_screen.dart';

class ChatScreen extends StatefulWidget {
  ChatData user;
  List<Conversation> chat;
  String? dp;
  String? mode;
  bool isHome;
  ChatScreen(
      {super.key,
      required this.user,
      required this.chat,
      this.dp,
      required this.isHome,
      required this.mode});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController? controiller = ScrollController();
  TextEditingController msgController = TextEditingController();
  IO.Socket? socket;

  bool showForm = false;
  String? toId;
  @override
  void initState() {
    super.initState();
    ModeController.handleMode("online");

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      UserProfileWare user =
          Provider.of<UserProfileWare>(context, listen: false);
      if (widget.user.conversations!.isNotEmpty) {
        if (widget.user.conversations!.last.sender ==
            user.userProfileModel.username) {
          setState(() {
            toId = widget.user.userTwoId.toString();
          });
        } else {
          setState(() {
            toId = widget.user.userOneId.toString();
          });
        }
      } else {
        setState(() {
          toId = user.publicUserProfileModel.id.toString();
        });
      }

      initSocket(toId!);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      UserProfileWare user =
          Provider.of<UserProfileWare>(context, listen: false);
      if (widget.user.conversations!.isNotEmpty) {
        if (widget.user.conversations!.last.sender ==
            user.userProfileModel.username) {
          setState(() {
            toId = widget.user.userTwoId.toString();
          });
        } else {
          setState(() {
            toId = widget.user.userOneId.toString();
          });
        }
      } else {
        setState(() {
          toId = user.publicUserProfileModel.id.toString();
        });
      }

      initSocket(toId!);
    });
  }

  @override
  void dispose() {
    socket!.disconnect();
    socket!.dispose();

    super.dispose();
  }

  Future<void> initSocket(String toId) async {
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    ChatWare ware = Provider.of<ChatWare>(context, listen: false);
    ware.addAllMsg(widget.chat);
    setState(() {
      showForm = false;
    });
    var messageMap = {
      "from": user.userProfileModel.id,
      "to": toId,
      "message": "Hey guy",
    };
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(tokenKey);
    socket = IO.io(
        "https://chat.macanacki.com/socket-chat-message",
        OptionBuilder().setTransports(['websocket']).setExtraHeaders(
            {"Authorization": "$token"}).build());
    socket!.connect();
    socket!.emit("addUserId", '${user.userProfileModel.id}');
    print("My id  is ${user.userProfileModel.id}  other user id is $toId");

    socket!.on("getUsers", (data) {
      if (data != null) {
        print(data);
      } else {
        print("null");
      }
    });
    // socket!.emit("sendMessage", messageMap);
    socket!.on("getMessage", (data) {
      if (data != null) {
        print("socket message recieved $data");
      } else {
        print("null");
      }
    });

    socket!.onConnect((_) {
      print('Connection established');
    });

    socket!.onConnectError((err) => print(err));
    socket!.onError((err) => print(err));
    socket!.onDisconnect((_) => print('Connection Disconnection'));
    print(socket!.connected);
    setState(() {
      showForm = true;
    });
    // ignore: use_build_context_synchronously
    //  ChatController.retrievChatController(context, false);
  }

  @override
  Widget build(BuildContext context) {
    bool? isOnline;
    var size = MediaQuery.of(context).size;
    var w = (size.width - 4 * 1) / 15;
    Temp stream = context.watch<Temp>();
    Temp temp = context.watch<Temp>();
    UserProfileWare ware = Provider.of<UserProfileWare>(context, listen: false);
    ChatWare myChat = context.watch<ChatWare>();
    if (widget.user.conversations!.isEmpty) {
      isOnline = false;
    } else {
      if (widget.user.conversations!.last.sender == temp.userName) {
        if (widget.user.userTwoMode == "online") {
          isOnline = true;
        } else {
          isOnline = false;
        }
      } else {
        if (widget.user.userOneMode == "Online") {
          isOnline = true;
        } else {
          isOnline = false;
        }
      }
    }

    return Scaffold(
      backgroundColor: HexColor("#F5F2F9"),
      appBar: AppBar(
        backgroundColor: HexColor(backgroundColor),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: InkWell(
          onTap: () {
            if (widget.user.conversations!.isNotEmpty) {
              String name =
                  widget.user.conversations!.last.sender == stream.userName
                      ? widget.user.userTwo!
                      : widget.user.userOne!;

              if (name == ware.userProfileModel.username) {
                PageRouting.pushToPage(context, const ProfileScreen());
              } else {
                PageRouting.pushToPage(
                    context,
                    UsersProfile(
                      username: name,
                    ));
              }
            }
          },
          child: Row(
            children: [
              Stack(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      HexagonWidget.pointy(
                        width: w + 4.0,
                        elevation: 3.0,
                        color: Colors.white,
                        cornerRadius: 7.0,
                        child: AspectRatio(
                          aspectRatio: HexagonType.POINTY.ratio,
                          // child: Image.asset(
                          //   'assets/tram.jpg',
                          //   fit: BoxFit.fitWidth,
                          // ),
                        ),
                      ),
                      widget.user.conversations!.isEmpty
                          ? HexagonAvatar(
                              url: widget.user.userTwoProfilePhoto == null
                                  ? widget.dp!
                                  : widget.user.userTwoProfilePhoto!,
                              w: w + 4)
                          : HexagonAvatar(
                              url: widget.user.conversations!.last.sender ==
                                      stream.userName
                                  ? widget.user.userTwoProfilePhoto!
                                  : widget.user.userOneProfilePhoto!,
                              w: w + 4),
                    ],
                  ),
                  Positioned(
                    right: 1.1,
                    top: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 0, bottom: 0),
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor:
                            widget.mode == "online" ? Colors.green : Colors.red,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              widget.user.conversations!.isNotEmpty
                  ? Row(
                      children: [
                        Container(
                          constraints: BoxConstraints(maxWidth: 150),
                          child: RichText(
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                              text: TextSpan(
                                text: widget.user.conversations!.last.sender ==
                                        stream.userName
                                    ? "${widget.user.userTwo}"
                                    : "${widget.user.userOne} ",

                                style: GoogleFonts.spartan(
                                  color: HexColor(darkColor),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                //     children: [
                                //   TextSpan(
                                //     text: widget.user.age,
                                //     style: GoogleFonts.spartan(
                                //         color: HexColor("#C0C0C0"), fontSize: 20),
                                //   )
                                // ]
                              )),
                        ),
                        // SvgPicture.asset(
                        //   "assets/icon/verifypink.svg",
                        //   height: 15,
                        //   width: 15,
                        // )
                      ],
                    )
                  : Row(
                      children: [
                        Container(
                          constraints: BoxConstraints(maxWidth: 150),
                          child: RichText(
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                              text: TextSpan(
                                text: "${widget.user.userTwo} ",

                                style: GoogleFonts.spartan(
                                  color: HexColor(darkColor),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                //     children: [
                                //   TextSpan(
                                //     text: widget.user.age,
                                //     style: GoogleFonts.spartan(
                                //         color: HexColor("#C0C0C0"), fontSize: 20),
                                //   )
                                // ]
                              )),
                        ),
                        // SvgPicture.asset(
                        //   "assets/icon/verifypink.svg",
                        //   height: 15,
                        //   width: 15,
                        // )
                      ],
                    ),
            ],
          ),
        ),

        // AppText(
        //   text: widget.user.name,
        //   color: HexColor(darkColor),
        //   size: 24,
        //   fontWeight: FontWeight.w700,
        // ),
        centerTitle: true,
        leading: BackButton(color: HexColor("#322929")),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
            child: InkWell(
              onTap: () => chatOptionModal(context),
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.0,
                        color: Colors.transparent,
                        style: BorderStyle.solid)),
                child: SvgPicture.asset(
                  "assets/icon/options.svg",
                  color: HexColor(darkColor),
                ),
              ),
            ),
          )
        ],
      ),
      body: StreamBuilder(
          stream: null,
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            text: "",
                            size: 14,
                            color: HexColor("#8B8B8B"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: widget.user.conversations!.isEmpty
                        ? ChatList(
                            chat: widget.chat,
                            me: ware.userProfileModel.username,
                            myUserId: ware.userProfileModel.id.toString(),
                            to: ware.publicUserProfileModel.username,
                            toUserId: ware.publicUserProfileModel.id.toString(),
                            controller: controiller!,
                            isHome: widget.isHome,
                          )
                        : ChatList(
                            chat: widget.chat,
                            me: widget.user.conversations!.last.sender ==
                                    stream.userName
                                ? widget.user.userOne!
                                : widget.user.userTwo!,
                            myUserId: ware.userProfileModel.id.toString(),
                            to: widget.user.conversations!.last.sender ==
                                    stream.userName
                                ? widget.user.userTwo
                                : widget.user.userOne,
                            toUserId: widget.user.conversations!.last.sender ==
                                    stream.userName
                                ? widget.user.userTwoId.toString()
                                : widget.user.userOneId.toString(),
                            controller: controiller!,
                            isHome: widget.isHome,
                          ),
                  ),
                  showForm
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: widget.user.conversations!.isEmpty
                              ? ChatForm(
                                  controller: controiller!,
                                  msgController: msgController,
                                  sendTo: ware.publicUserProfileModel.username!,
                                  chat: widget.user,
                                  socket: socket == null ? null : socket!,
                                  toId:
                                      ware.publicUserProfileModel.id!.toString()

                                  //  val: controiller!.position.maxScrollExtent,
                                  )
                              : ChatForm(
                                  controller: controiller!,
                                  msgController: msgController,
                                  sendTo:
                                      widget.user.conversations!.last.sender ==
                                              stream.userName
                                          ? widget.user.userTwo!
                                          : widget.user.userOne!,
                                  chat: widget.user,
                                  socket: socket == null ? null : socket!,
                                  toId:
                                      widget.user.conversations!.last.sender ==
                                              stream.userName
                                          ? widget.user.userTwoId.toString()
                                          : widget.user.userOneId.toString(),
                                  //  val: controiller!.position.maxScrollExtent,
                                ))
                      : const SizedBox.shrink()
                ],
              ),
            );
          }),
    );
  }
}
