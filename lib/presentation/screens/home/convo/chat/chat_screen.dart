import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:just_audio/just_audio.dart';
import 'package:macanacki/presentation/screens/home/convo/chat/chatextra/chat_field.dart';
import 'package:macanacki/presentation/screens/home/convo/chat/chatextra/chat_grid.dart';
import 'package:macanacki/presentation/screens/home/convo/chat/chatextra/option_menu.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/controllers/chat_controller.dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
import 'package:macanacki/services/temps/temp.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../model/conversation_model.dart';
import '../../../../../model/public_profile_model.dart';
import '../../../../../services/controllers/mode_controller.dart';
import '../../../../../services/middleware/chat_ware.dart';
import '../../../../../services/temps/temps_id.dart';
import '../../../../allNavigation.dart';
import '../../../../constants/colors.dart';
import '../../../../uiproviders/screen/tab_provider.dart';
import '../../../../widgets/avatar.dart';
import '../../../../widgets/hexagon_avatar.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:macanacki/services/api_url.dart';
import '../../../userprofile/testing_profile.dart';
import '../../../userprofile/user_profile_screen.dart';
import '../../profile/profile_screen.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_session/audio_session.dart';

class ChatScreen extends StatefulWidget {
  ChatData user;
  List<Conversation> chat;
  String? dp;
  String? mode;
  bool isHome;
  int verified;
  PublicUserData? otherUser;
  ChatScreen(
      {super.key,
      required this.user,
      required this.chat,
      this.dp,
      required this.verified,
      required this.isHome,
      this.otherUser,
      required this.mode});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController? controiller = ScrollController();
  TextEditingController msgController = TextEditingController();
  final player = AudioPlayer();
  final player2 = AudioPlayer();
  int? verify = 0;
  bool showForm = false;
  String? toId;
  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.

    // Try to load audio from a source and catch any errors.
    try {
      await player.setAsset(
        "assets/sound/send0.mp3",
      );
      player.play();

      setState(() {});
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void initState() {
    // _init();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (PersistentNavController.instance.hide.value == false) {
        PersistentNavController.instance.toggleHide();
      }

      // Future.delayed(Duration(seconds: 3), () {
      //   if (VideoWareHome.instance.hide.value == true) {
      //     //fadeOutAndUpdateState();
      //     //  VideoWareHome.instance.hideButtons();
      //   }
      // });
    });
    ChatController.initSocket(context)
        .whenComplete(() => ChatController.addUserToSocket(context));
    super.initState();
    if (widget.isHome) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ChatWare ware = Provider.of<ChatWare>(context, listen: false);
        ware.addNewChatData(widget.user);
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ChatWare chat = Provider.of<ChatWare>(context, listen: false);
      chat.addAllMsg(widget.chat, widget.user.id);
      UserProfileWare ware =
          Provider.of<UserProfileWare>(context, listen: false);
      Temp temp = Provider.of<Temp>(context, listen: false);

      widget.user.conversations!.isEmpty
          ? ChatController.readAll(context, widget.otherUser!.id!)
          : ChatController.readAll(
              context,
              widget.user.conversations!.last.sender == temp.userName
                  ? widget.user.userTwoId!
                  : widget.user.userOneId!);

      chat.chatPageChange(0);
      chat.addChatName(widget.user.conversations!.last.sender ==
              ware.userProfileModel.username
          ? "${widget.user.userTwo}"
          : "${widget.user.userOne} ");
    });

    // ModeController.handleMode("online");

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      UserProfileWare user =
          Provider.of<UserProfileWare>(context, listen: false);
      if (widget.user.conversations!.isNotEmpty) {
        if (widget.user.conversations!.last.sender ==
            user.userProfileModel.username) {
          setState(() {
            toId = widget.user.userTwoId.toString();
            verify = widget.user.userTwoId;
          });
        } else {
          setState(() {
            toId = widget.user.userOneId.toString();
            verify = widget.user.userOneVerify;
          });
        }
      } else {
        setState(() {
          toId = widget.otherUser!.id.toString();
        });
      }

      //   initSocket(toId!);
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
          toId = widget.otherUser!.id.toString();
        });
      }

      //   initSocket(toId!);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //    ChatWare chat = Provider.of<ChatWare>(context, listen: false);
    //   ChatController.readAll(context, int.tryParse(toId!)!);
    //   if (mounted) {

    //     if (chat.chatPage != 0) {
    //       ChatController.changeChatPage(context, 0);
    //     }
    //   } else {
    //     ChatWare chat = Provider.of<ChatWare>(context, listen: false);
    //     if (chat.chatPage != 0) {
    //       ChatController.changeChatPage(context, 0);
    //     }
    //     emitter("Did not work");
    //   }
    // });
  }

  @override
  void dispose() {
    // socket!.disconnect();
    // socket!.dispose();
    player.dispose();

    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      PersistentNavController.instance.toggleHide();
    });
  }

  bool leaving = false;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (PersistentNavController.instance.hide.value == false) {
        PersistentNavController.instance.toggleHide();
      }

      // Future.delayed(Duration(seconds: 3), () {
      //   if (VideoWareHome.instance.hide.value == true) {
      //     //fadeOutAndUpdateState();
      //     //  VideoWareHome.instance.hideButtons();
      //   }
      // });
    });
    bool? isOnline;
    dynamic id;
    var size = MediaQuery.of(context).size;
    var w = (size.width - 4 * 1) / 15;
    Temp stream = context.watch<Temp>();
    Temp temp = context.watch<Temp>();
    UserProfileWare myAccount =
        Provider.of<UserProfileWare>(context, listen: false);
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

    if (widget.isHome) {
      if (widget.user.conversations!.last.sender == temp.userName) {
        id = widget.user.userTwoId!;
      } else {
        id = widget.user.userOneId!;
      }
    } else {
      id = widget.otherUser!.id;
    }

    if (myChat.chatPage == 0 && leaving == false) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ChatController.changeChatPage(context, id);
      });
    }

    return WillPopScope(
      onWillPop: () {
        ChatWare ware = Provider.of<ChatWare>(context, listen: false);
        setState(() {
          leaving = true;
        });
        if (myChat.chatPage != 0) {
          ChatController.changeChatPage(context, 0);
        }

        Navigator.pop(context, [widget.user, ware.newConversationData]);
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: HexColor(backgroundColor),
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

                  if (name == myAccount.userProfileModel.username) {
                    PageRouting.pushToPage(context, const ProfileScreen());
                  } else {
                    PageRouting.pushToPage(
                        context,
                        TestProfile(
                          username: name,
                          extended: true,
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
                          widget.user.conversations!.isEmpty
                              ? Avatar(
                                  radius: 15,
                                  image: widget.user.userTwoProfilePhoto == null
                                      ? widget.dp!
                                      : widget.user.userTwoProfilePhoto!,
                                )
                              : Avatar(
                                  radius: 15,
                                  image:
                                      widget.user.conversations!.last.sender ==
                                              stream.userName
                                          ? widget.user.userTwoProfilePhoto!
                                          : widget.user.userOneProfilePhoto!,
                                ),
                          // HexagonWidget.pointy(
                          //   width: w + 4.0,
                          //   elevation: 3.0,
                          //   color: backgroundSecondary,
                          //   cornerRadius: 7.0,
                          //   child: AspectRatio(
                          //     aspectRatio: HexagonType.POINTY.ratio,
                          //     // child: Image.asset(
                          //     //   'assets/tram.jpg',
                          //     //   fit: BoxFit.fitWidth,
                          //     // ),
                          //   ),
                          // ),
                          // widget.user.conversations!.isEmpty
                          //     ? HexagonAvatar(
                          //         url: widget.user.userTwoProfilePhoto == null
                          //             ? widget.dp!
                          //             : widget.user.userTwoProfilePhoto!,
                          //         w: w + 4)
                          //     : HexagonAvatar(
                          //         url: widget.user.conversations!.last.sender ==
                          //                 stream.userName
                          //             ? widget.user.userTwoProfilePhoto!
                          //             : widget.user.userOneProfilePhoto!,
                          //         w: w + 4),
                        ],
                      ),
                      Positioned(
                        right: 1.1,
                        top: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 0, bottom: 0),
                          child: CircleAvatar(
                            radius: 3,
                            backgroundColor: myChat.allSocketUsers
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
                                    text: widget.user.conversations!.last
                                                .sender ==
                                            stream.userName
                                        ? "${widget.user.userTwo}"
                                        : "${widget.user.userOne} ",

                                    style: GoogleFonts.roboto(
                                      color: textWhite,
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
                            widget.verified == 0
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.only(left: 3),
                                    child: SvgPicture.asset(
                                      "assets/icon/badge.svg",
                                      height: 13,
                                      width: 13,
                                    ),
                                  )
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

                                    style: GoogleFonts.roboto(
                                      color: textWhite,
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
                            widget.verified == 0
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.only(left: 3),
                                    child: SvgPicture.asset(
                                      "assets/icon/badge.svg",
                                      height: 13,
                                      width: 13,
                                    ),
                                  )
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
            leading: BackButton(
              color: textPrimary,
              onPressed: () async {
                ChatWare ware = Provider.of<ChatWare>(context, listen: false);
                setState(() {
                  leaving = true;
                });
                if (myChat.chatPage != 0) {
                  ChatController.changeChatPage(context, 0);
                }
                Navigator.pop(context, [widget.user, ware.newConversationData]);
              },
            ),
            actions: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
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
                      color: textPrimary,
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
                  padding: const EdgeInsets.symmetric(horizontal: 0),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Align(
                          alignment: Alignment.center,
                          child: widget.user.conversations!.isEmpty
                              ? ChatList(
                                  chat: widget.chat,
                                  me: myAccount.userProfileModel.username,
                                  myUserId:
                                      myAccount.userProfileModel.id.toString(),
                                  to: widget.otherUser!.username,
                                  toUserId: widget.otherUser!.id.toString(),
                                  controller: controiller!,
                                  isHome: widget.isHome,
                                  user: widget.user,
                                  //   player: player2,
                                )
                              : ChatList(
                                  chat: widget.chat,
                                  me: widget.user.conversations!.last.sender ==
                                          stream.userName
                                      ? widget.user.userOne!
                                      : widget.user.userTwo!,
                                  myUserId:
                                      myAccount.userProfileModel.id.toString(),
                                  to: widget.user.conversations!.last.sender ==
                                          stream.userName
                                      ? widget.user.userTwo
                                      : widget.user.userOne,
                                  toUserId:
                                      widget.user.conversations!.last.sender ==
                                              stream.userName
                                          ? widget.user.userTwoId.toString()
                                          : widget.user.userOneId.toString(),
                                  controller: controiller!,
                                  isHome: widget.isHome,
                                  user: widget.user,
                                  player: player2,
                                ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: widget.user.conversations!.isEmpty
                              ? ChatForm(
                                  controller: controiller!,
                                  msgController: msgController,
                                  sendTo: widget.otherUser!.username!,
                                  chat: widget.user,
                                  socket: myChat.socket == null
                                      ? null
                                      : myChat.socket!,
                                  toId: widget.otherUser!.id!.toString(),
                                  player: player,

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
                                  socket: myChat.socket == null
                                      ? null
                                      : myChat.socket!,
                                  toId:
                                      widget.user.conversations!.last.sender ==
                                              stream.userName
                                          ? widget.user.userTwoId.toString()
                                          : widget.user.userOneId.toString(),
                                  player: player,
                                  //  val: controiller!.position.maxScrollExtent,
                                ))
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
