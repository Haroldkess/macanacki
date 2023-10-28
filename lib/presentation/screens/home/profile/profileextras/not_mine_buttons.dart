import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/model/conversation_model.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/screens/home/convo/chat/chat_screen.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/presentation/widgets/loader.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/controllers/chat_controller.dart';
import 'package:macanacki/services/controllers/url_launch_controller.dart';
import 'package:macanacki/services/middleware/chat_ware.dart';
import 'package:provider/provider.dart';
import '../../../../../model/public_profile_model.dart';
import '../../../../../services/controllers/action_controller.dart';
import '../../../../../services/middleware/action_ware.dart';
import '../../../../../services/middleware/extra_profile_ware.dart';
import '../../../../../services/middleware/user_profile_ware.dart';
import '../../../../constants/colors.dart';
import '../../../../widgets/text.dart';

class ProfileActionButtonNotThisUsers extends StatelessWidget {
  final String icon;
  VoidCallback onClick;
  String? color;
  bool isSwipe;

  ProfileActionButtonNotThisUsers(
      {super.key,
      required this.icon,
      required this.onClick,
      required this.color,
      required this.isSwipe});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(80),
          //set border radius more than 50% of height and width to make circle
        ),
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              icon,
              height: isSwipe ? 22 : null,
              width: isSwipe ? 22 : null,
              color: color == null ? null : HexColor(color!),
            ),
          ),
        ),
      ),
    );
  }
}

class UserProfileActions extends StatelessWidget {
  const UserProfileActions({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.width;
    ActionWare stream = context.watch<ActionWare>();
    UserProfileWare data = context.watch<UserProfileWare>();
    ChatWare chatWareStream = context.watch<ChatWare>();

    return Container(
      width: 220,
      height: 80,
      //  color: Colors.amber,
      child: data.publicUserProfileModel.gender == "Business"
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                data.publicUserProfileModel.gender == "Business"
                    ? InkWell(
                        //   onTap: () => PageRouting.pushToPage(context, const EditProfile()),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ProfileActionButtonNotThisUsers(
                              icon: "assets/icon/call.svg",
                              isSwipe: false,
                              onClick: () async {
                                UserProfileWare data =
                                    Provider.of<UserProfileWare>(context,
                                        listen: false);
                                if (data.publicUserProfileModel.phone == null) {
                                  showToast2(context,
                                      "Can't reach this Business at the moment",
                                      isError: true);
                                } else {
                                  UrlLaunchController.makePhoneCall(
                                      data.publicUserProfileModel.phone ?? "");
                                }
                              },
                              color: "#FFC1D6",
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: 50,
                              alignment: Alignment.center,
                              // color: Colors.amber,
                              child: AppText(
                                text: "Call",
                                fontWeight: FontWeight.w400,
                                size: 10,
                                color: HexColor("#797979"),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                InkWell(
                  onTap: () async {
                    //   print("dfdd");
                    await followAction(context, data.publicUserProfileModel.id!,
                        data.publicUserProfileModel.username!);
                  },
                  child: AnimatedContainer(
                    duration: Duration(seconds: 2),
                    child: Column(
                      mainAxisAlignment:
                          data.publicUserProfileModel.gender == "Business"
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.center,
                      children: [
                        ProfileActionButtonNotThisUsers(
                          icon: "assets/icon/follow.svg",
                          isSwipe: false,
                          onClick: () async {
                            await followAction(
                              context,
                              data.publicUserProfileModel.id!,
                              data.publicUserProfileModel.username!,
                            );
                          },
                          color: !stream.followIds
                                  .contains(data.publicUserProfileModel.id)
                              ? "#F94C84"
                              : "#FFC1D6",
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        AnimatedContainer(
                          width: 50,
                          alignment: Alignment.center,
                          //color: Colors.amber,
                          duration: Duration(seconds: 2),

                          child: !stream.followIds
                                  .contains(data.publicUserProfileModel.id)
                              ? AppText(
                                  text: "Follow",
                                  fontWeight: FontWeight.w400,
                                  size: 10,
                                  color: HexColor("#797979"),
                                )
                              : AppText(
                                  text: "Unfollow",
                                  fontWeight: FontWeight.w400,
                                  size: 10,
                                  color: HexColor("#797979"),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 4,
                      ),
                      chatWareStream.loadStatus
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Loader(color: HexColor(primaryColor)),
                            )
                          : ProfileActionButtonNotThisUsers(
                              isSwipe: false,
                              icon: "assets/icon/userchat.svg",
                              onClick: () async {
                                late ChatData chat;
                                ChatWare chatWare = Provider.of<ChatWare>(
                                    context,
                                    listen: false);
                                await ChatController.retrievChatController(
                                    context, true, false);
                                List<Conversation> empty = [];

                                late int statusId;
                                late int id;
                                late ChatData chatData;

                                if (chatWare.chatList.isEmpty) {
                                  statusId = 0;

                                  id = 0;

                                  chatData = ChatData(
                                    status: statusId,
                                    id: id,
                                    userOne: data.userProfileModel.username,
                                    userOneProfilePhoto:
                                        data.userProfileModel.profilephoto,
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                    blockedBy: null,
                                    userTwo:
                                        data.publicUserProfileModel.username,
                                    userTwoProfilePhoto: data
                                        .publicUserProfileModel.profilephoto,
                                    conversations: empty,
                                  );
                                } else {
                                  statusId =
                                      chatWare.chatList.first.status! + 1;

                                  id = chatWare.chatList.first.id! + 1;

                                  chatData = ChatData(
                                    status: statusId,
                                    id: id,
                                    userOne: data.userProfileModel.username,
                                    userOneProfilePhoto:
                                        data.userProfileModel.profilephoto,
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                    blockedBy: null,
                                    userTwo:
                                        data.publicUserProfileModel.username,
                                    userTwoProfilePhoto: data
                                        .publicUserProfileModel.profilephoto,
                                    conversations: empty,
                                  );
                                }

                                bool seen = false;

                                await Future.forEach(chatWare.chatList,
                                    (element) async {
                                  // ignore: unrelated_type_equality_checks
                                  if (element.userTwo ==
                                      data.publicUserProfileModel.username) {
                                    seen = true;
                                    chat = element;
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: element,
                                          chat: element.conversations!,
                                          dp: data.publicUserProfileModel
                                              .profilephoto,
                                          mode:
                                              data.publicUserProfileModel.mode,
                                          isHome: false,
                                          verified: data
                                              .publicUserProfileModel.verified!,
                                        ));
                                    return;
                                  } else if (element.userOne ==
                                      data.publicUserProfileModel.username) {
                                    chat = element;
                                    seen = true;
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: element,
                                          chat: element.conversations!,
                                          dp: data.publicUserProfileModel
                                              .profilephoto,
                                          mode: data.publicUserProfileModel
                                              .profilephoto,
                                          isHome: false,
                                          verified: data
                                              .publicUserProfileModel.verified!,
                                        ));
                                    return;
                                  } else {
                                    chat = ChatData();
                                  }
                                });

                                if (seen) {
                                  return;
                                  // ignore: use_build_context_synchronously
                                } else {
                                  List<ChatData> checker = chatWareStream
                                      .chatList2
                                      .where((element) =>
                                          element.userTwo ==
                                          data.publicUserProfileModel.username)
                                      .toList();
                                  List<ChatData> checker2 = chatWareStream
                                      .chatList2
                                      .where((element) =>
                                          element.userOne ==
                                          data.publicUserProfileModel.username)
                                      .toList();
                                  if (checker.isNotEmpty && checker2.isEmpty) {
                                    // ignore: use_build_context_synchronously
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: checker.first,
                                          chat: checker.first.conversations!,
                                          dp: data.publicUserProfileModel
                                              .profilephoto,
                                          mode:
                                              data.publicUserProfileModel.mode,
                                          isHome: false,
                                          verified: data
                                              .publicUserProfileModel.verified!,
                                        ));
                                  } else if (checker.isEmpty &&
                                      checker2.isNotEmpty) {
                                    // ignore: use_build_context_synchronously
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: checker2.first,
                                          chat: checker2.first.conversations!,
                                          dp: data.publicUserProfileModel
                                              .profilephoto,
                                          mode:
                                              data.publicUserProfileModel.mode,
                                          isHome: false,
                                          verified: data
                                              .publicUserProfileModel.verified!,
                                        ));
                                  } else {
                                    // ignore: use_build_context_synchronously

                                    // ignore: use_build_context_synchronously
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: chatData,
                                          chat: empty,
                                          dp: data.publicUserProfileModel
                                              .profilephoto,
                                          mode:
                                              data.publicUserProfileModel.mode,
                                          isHome: false,
                                          verified: data
                                              .publicUserProfileModel.verified!,
                                        ));
                                  }

                                  // ignore: use_build_context_synchronously
                                }

                                // chat = chatWare.chatList
                                //     // ignore: unrelated_type_equality_checks
                                //     .where((element) {
                                //       final val = element.conversations!.last == "kelt"
                                //           ? element.userTwo
                                //           : element.userOne;
                                //       final val2 = data.publicUserProfileModel.username;

                                //       return val == val2;
                                //     })
                                //     .toList()
                                //     .single;

                                // if (chat.conversations!.isNotEmpty) {
                                //   // ignore: use_build_context_synchronously
                                //   PageRouting.pushToPage(context,
                                //       ChatScreen(user: chat, chat: chat.conversations!));
                                // } else {
                                //   // ignore: use_build_context_synchronously
                                //   PageRouting.pushToPage(
                                //       context, ChatScreen(user: chatData, chat: empty));
                                // }

                                emitter("not exist");

                                // PageRouting.pushToPage(
                                //     context, ChatScreen(user: user, chat: chat));
                              },
                              color: "#FFC1D6",
                            ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 50,
                        alignment: Alignment.center,
                        //  color: Colors.amber,
                        child: AppText(
                          text: chatWareStream.loadStatus ? "" : "Message",
                          fontWeight: FontWeight.w400,
                          size: 10,
                          color: HexColor("#797979"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  //   onTap: () => PageRouting.pushToPage(context, const EditProfile()),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ProfileActionButtonNotThisUsers(
                        icon: "assets/icon/email.svg",
                        isSwipe: true,
                        onClick: () async {
                          UserProfileWare data = Provider.of<UserProfileWare>(
                              context,
                              listen: false);
                          if (data.publicUserProfileModel.email == null ||
                              data.publicUserProfileModel.email!.isEmpty) {
                            showToast2(
                                context, "Can't reach this user at the moment",
                                isError: true);
                          } else {
                            final url =
                                'mailTo:${data.publicUserProfileModel.email}?subject=${Uri.encodeFull("From a follower on Macanacki")}&body=${Uri.encodeFull("Sending from my device")}';

                            UrlLaunchController.launchInWebViewOrVC(
                                Uri.parse(url));
                          }
                        },
                        color: "#FFC1D6",
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 70, minWidth: 50),
                        alignment: Alignment.center,
                        // color: Colors.amber,
                        child: AppText(
                          text: "Email",
                          fontWeight: FontWeight.w400,
                          size: 10,
                          color: HexColor("#797979"),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await followAction(context, data.publicUserProfileModel.id!,
                        data.publicUserProfileModel.username!);
                  },
                  child: AnimatedContainer(
                    duration: Duration(seconds: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ProfileActionButtonNotThisUsers(
                          icon: "assets/icon/follow.svg",
                          isSwipe: false,
                          onClick: () async {
                            await followAction(
                              context,
                              data.publicUserProfileModel.id!,
                              data.publicUserProfileModel.username!,
                            );
                          },
                          color: !stream.followIds
                                  .contains(data.publicUserProfileModel.id)
                              ? "#F94C84"
                              : "#FFC1D6",
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        AnimatedContainer(
                          constraints:
                              BoxConstraints(maxWidth: 70, minWidth: 50),
                          alignment: Alignment.center,
                          //color: Colors.amber,
                          duration: Duration(seconds: 2),

                          child: !stream.followIds
                                  .contains(data.publicUserProfileModel.id)
                              ? AppText(
                                  text: "Follow",
                                  fontWeight: FontWeight.w400,
                                  size: 10,
                                  color: HexColor("#797979"),
                                )
                              : AppText(
                                  text: "Unfollow",
                                  fontWeight: FontWeight.w400,
                                  size: 10,
                                  color: HexColor("#797979"),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // const SizedBox(
                      //   height: 4,
                      // ),
                      chatWareStream.loadStatus
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Loader(color: HexColor(primaryColor)),
                            )
                          : ProfileActionButtonNotThisUsers(
                              isSwipe: false,
                              icon: "assets/icon/userchat.svg",
                              onClick: () async {
                                ChatWare chatWare = Provider.of<ChatWare>(
                                    context,
                                    listen: false);
                                await ChatController.retrievChatController(
                                    context, true, false);
                                late ChatData chat;

                                List<Conversation> empty = [];

                                late int statusId;
                                late int id;
                                late ChatData chatData;

                                if (chatWare.chatList.isEmpty) {
                                  statusId = 0;

                                  id = 0;

                                  chatData = ChatData(
                                    status: statusId,
                                    id: id,
                                    userOne: data.userProfileModel.username,
                                    userOneProfilePhoto:
                                        data.userProfileModel.profilephoto,
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                    blockedBy: null,
                                    userTwo:
                                        data.publicUserProfileModel.username,
                                    userTwoProfilePhoto: data
                                        .publicUserProfileModel.profilephoto,
                                    conversations: empty,
                                  );
                                } else {
                                  statusId =
                                      chatWare.chatList.first.status! + 1;

                                  id = chatWare.chatList.first.id! + 1;

                                  chatData = ChatData(
                                    status: statusId,
                                    id: id,
                                    userOne: data.userProfileModel.username,
                                    userOneProfilePhoto:
                                        data.userProfileModel.profilephoto,
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                    blockedBy: null,
                                    userTwo:
                                        data.publicUserProfileModel.username,
                                    userTwoProfilePhoto: data
                                        .publicUserProfileModel.profilephoto,
                                    conversations: empty,
                                  );
                                }

                                bool seen = false;

                                await Future.forEach(chatWare.chatList,
                                    (element) async {
                                  // ignore: unrelated_type_equality_checks
                                  if (element.userTwo ==
                                      data.publicUserProfileModel.username) {
                                    seen = true;
                                    chat = element;
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: element,
                                          chat: element.conversations!,
                                          dp: data.publicUserProfileModel
                                              .profilephoto,
                                          mode:
                                              data.publicUserProfileModel.mode,
                                          isHome: false,
                                          verified: data
                                              .publicUserProfileModel.verified!,
                                        ));
                                    return;
                                  } else if (element.userOne ==
                                      data.publicUserProfileModel.username) {
                                    chat = element;
                                    seen = true;
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: element,
                                          chat: element.conversations!,
                                          dp: data.publicUserProfileModel
                                              .profilephoto,
                                          mode: data.publicUserProfileModel
                                              .profilephoto,
                                          isHome: false,
                                          verified: data
                                              .publicUserProfileModel.verified!,
                                        ));
                                    return;
                                  } else {
                                    chat = ChatData();
                                  }
                                });

                                if (seen) {
                                  return;
                                  // ignore: use_build_context_synchronously
                                } else {
                                  List<ChatData> checker = chatWareStream
                                      .chatList2
                                      .where((element) =>
                                          element.userTwo ==
                                          data.publicUserProfileModel.username)
                                      .toList();
                                  List<ChatData> checker2 = chatWareStream
                                      .chatList2
                                      .where((element) =>
                                          element.userOne ==
                                          data.publicUserProfileModel.username)
                                      .toList();
                                  if (checker.isNotEmpty && checker2.isEmpty) {
                                    // ignore: use_build_context_synchronously
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: checker.first,
                                          chat: checker.first.conversations!,
                                          dp: data.publicUserProfileModel
                                              .profilephoto,
                                          mode:
                                              data.publicUserProfileModel.mode,
                                          isHome: false,
                                          verified: data
                                              .publicUserProfileModel.verified!,
                                        ));
                                  } else if (checker.isEmpty &&
                                      checker2.isNotEmpty) {
                                    // ignore: use_build_context_synchronously
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: checker2.first,
                                          chat: checker2.first.conversations!,
                                          dp: data.publicUserProfileModel
                                              .profilephoto,
                                          mode:
                                              data.publicUserProfileModel.mode,
                                          isHome: false,
                                          verified: data
                                              .publicUserProfileModel.verified!,
                                        ));
                                  } else {
                                    // ignore: use_build_context_synchronously

                                    // ignore: use_build_context_synchronously
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: chatData,
                                          chat: empty,
                                          dp: data.publicUserProfileModel
                                              .profilephoto,
                                          mode:
                                              data.publicUserProfileModel.mode,
                                          isHome: false,
                                          verified: data
                                              .publicUserProfileModel.verified!,
                                        ));
                                  }

                                  // ignore: use_build_context_synchronously
                                }

                                // chat = chatWare.chatList
                                //     // ignore: unrelated_type_equality_checks
                                //     .where((element) {
                                //       final val = element.conversations!.last == "kelt"
                                //           ? element.userTwo
                                //           : element.userOne;
                                //       final val2 = data.publicUserProfileModel.username;

                                //       return val == val2;
                                //     })
                                //     .toList()
                                //     .single;

                                // if (chat.conversations!.isNotEmpty) {
                                //   // ignore: use_build_context_synchronously
                                //   PageRouting.pushToPage(context,
                                //       ChatScreen(user: chat, chat: chat.conversations!));
                                // } else {
                                //   // ignore: use_build_context_synchronously
                                //   PageRouting.pushToPage(
                                //       context, ChatScreen(user: chatData, chat: empty));
                                // }

                                // PageRouting.pushToPage(
                                //     context, ChatScreen(user: user, chat: chat));
                              },
                              color: "#FFC1D6",
                            ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 70, minWidth: 50),
                        alignment: Alignment.center,
                        //color: Colors.amber,
                        child: AppText(
                          text: chatWareStream.loadStatus ? "" : "Message",
                          fontWeight: FontWeight.w400,
                          size: 10,
                          color: HexColor("#797979"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> followAction(
      BuildContext context, int id, String username) async {
    ActionWare provide = Provider.of<ActionWare>(context, listen: false);

    //provide.addFollowId(id);
    await ActionController.followOrUnFollowController(context, username, id);
  }
}

class UserProfileActionsExtra extends StatelessWidget {
  const UserProfileActionsExtra({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.width;
    ActionWare stream = context.watch<ActionWare>();
    ExtraProfileWare data = context.watch<ExtraProfileWare>();
    ChatWare chatWareStream = context.watch<ChatWare>();

    return Container(
      width: 220,
      height: 80,
      //  color: Colors.amber,
      child: data.publicUserProfileModel.gender == "Business"
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                data.publicUserProfileModel.gender == "Business"
                    ? InkWell(
                        //   onTap: () => PageRouting.pushToPage(context, const EditProfile()),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ProfileActionButtonNotThisUsers(
                              icon: "assets/icon/call.svg",
                              isSwipe: false,
                              onClick: () async {
                                UserProfileWare data =
                                    Provider.of<UserProfileWare>(context,
                                        listen: false);
                                if (data.publicUserProfileModel.phone == null) {
                                  showToast2(context,
                                      "Can't reach this Business at the moment",
                                      isError: true);
                                } else {
                                  UrlLaunchController.makePhoneCall(
                                      data.publicUserProfileModel.phone ?? "");
                                }
                              },
                              color: "#FFC1D6",
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: 50,
                              alignment: Alignment.center,
                              // color: Colors.amber,
                              child: AppText(
                                text: "Call",
                                fontWeight: FontWeight.w400,
                                size: 10,
                                color: HexColor("#797979"),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                InkWell(
                  onTap: () async {
                    //   print("dfdd");
                    await followAction(context, data.publicUserProfileModel.id!,
                        data.publicUserProfileModel.username!);
                  },
                  child: AnimatedContainer(
                    duration: Duration(seconds: 2),
                    child: Column(
                      mainAxisAlignment:
                          data.publicUserProfileModel.gender == "Business"
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.center,
                      children: [
                        ProfileActionButtonNotThisUsers(
                          icon: "assets/icon/follow.svg",
                          isSwipe: false,
                          onClick: () async {
                            await followAction(
                              context,
                              data.publicUserProfileModel.id!,
                              data.publicUserProfileModel.username!,
                            );
                          },
                          color: !stream.followIds
                                  .contains(data.publicUserProfileModel.id)
                              ? "#F94C84"
                              : "#FFC1D6",
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        AnimatedContainer(
                          width: 50,
                          alignment: Alignment.center,
                          //color: Colors.amber,
                          duration: Duration(seconds: 2),

                          child: !stream.followIds
                                  .contains(data.publicUserProfileModel.id)
                              ? AppText(
                                  text: "Follow",
                                  fontWeight: FontWeight.w400,
                                  size: 10,
                                  color: HexColor("#797979"),
                                )
                              : AppText(
                                  text: "Unfollow",
                                  fontWeight: FontWeight.w400,
                                  size: 10,
                                  color: HexColor("#797979"),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 4,
                      ),
                      chatWareStream.loadStatus
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Loader(color: HexColor(primaryColor)),
                            )
                          : ProfileActionButtonNotThisUsers(
                              isSwipe: false,
                              icon: "assets/icon/userchat.svg",
                              onClick: () async {
                                late ChatData chat;
                                ChatWare chatWare = Provider.of<ChatWare>(
                                    context,
                                    listen: false);
                                await ChatController.retrievChatController(
                                    context, true, false);
                                List<Conversation> empty = [];

                                late int statusId;
                                late int id;
                                late ChatData chatData;

                                if (chatWare.chatList.isEmpty) {
                                  statusId = 0;

                                  id = 0;

                                  chatData = ChatData(
                                    status: statusId,
                                    id: id,
                                    userOne: data.userProfileModel.username,
                                    userOneProfilePhoto:
                                        data.userProfileModel.profilephoto,
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                    blockedBy: null,
                                    userTwo:
                                        data.publicUserProfileModel.username,
                                    userTwoProfilePhoto: data
                                        .publicUserProfileModel.profilephoto,
                                    conversations: empty,
                                  );
                                } else {
                                  statusId =
                                      chatWare.chatList.first.status! + 1;

                                  id = chatWare.chatList.first.id! + 1;

                                  chatData = ChatData(
                                    status: statusId,
                                    id: id,
                                    userOne: data.userProfileModel.username,
                                    userOneProfilePhoto:
                                        data.userProfileModel.profilephoto,
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                    blockedBy: null,
                                    userTwo:
                                        data.publicUserProfileModel.username,
                                    userTwoProfilePhoto: data
                                        .publicUserProfileModel.profilephoto,
                                    conversations: empty,
                                  );
                                }

                                bool seen = false;

                                await Future.forEach(chatWare.chatList,
                                    (element) async {
                                  // ignore: unrelated_type_equality_checks
                                  if (element.userTwo ==
                                      data.publicUserProfileModel.username) {
                                    seen = true;
                                    chat = element;
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: element,
                                          chat: element.conversations!,
                                          dp: data.publicUserProfileModel
                                              .profilephoto,
                                          mode:
                                              data.publicUserProfileModel.mode,
                                          isHome: false,
                                          verified: data
                                              .publicUserProfileModel.verified!,
                                        ));
                                    return;
                                  } else if (element.userOne ==
                                      data.publicUserProfileModel.username) {
                                    chat = element;
                                    seen = true;
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: element,
                                          chat: element.conversations!,
                                          dp: data.publicUserProfileModel
                                              .profilephoto,
                                          mode: data.publicUserProfileModel
                                              .profilephoto,
                                          isHome: false,
                                          verified: data
                                              .publicUserProfileModel.verified!,
                                        ));
                                    return;
                                  } else {
                                    chat = ChatData();
                                  }
                                });

                                if (seen) {
                                  return;
                                  // ignore: use_build_context_synchronously
                                } else {
                                  List<ChatData> checker = chatWareStream
                                      .chatList2
                                      .where((element) =>
                                          element.userTwo ==
                                          data.publicUserProfileModel.username)
                                      .toList();
                                  List<ChatData> checker2 = chatWareStream
                                      .chatList2
                                      .where((element) =>
                                          element.userOne ==
                                          data.publicUserProfileModel.username)
                                      .toList();
                                  if (checker.isNotEmpty && checker2.isEmpty) {
                                    // ignore: use_build_context_synchronously
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: checker.first,
                                          chat: checker.first.conversations!,
                                          dp: data.publicUserProfileModel
                                              .profilephoto,
                                          mode:
                                              data.publicUserProfileModel.mode,
                                          isHome: false,
                                          verified: data
                                              .publicUserProfileModel.verified!,
                                        ));
                                  } else if (checker.isEmpty &&
                                      checker2.isNotEmpty) {
                                    // ignore: use_build_context_synchronously
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: checker2.first,
                                          chat: checker2.first.conversations!,
                                          dp: data.publicUserProfileModel
                                              .profilephoto,
                                          mode:
                                              data.publicUserProfileModel.mode,
                                          isHome: false,
                                          verified: data
                                              .publicUserProfileModel.verified!,
                                        ));
                                  } else {
                                    // ignore: use_build_context_synchronously

                                    // ignore: use_build_context_synchronously
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: chatData,
                                          chat: empty,
                                          dp: data.publicUserProfileModel
                                              .profilephoto,
                                          mode:
                                              data.publicUserProfileModel.mode,
                                          isHome: false,
                                          verified: data
                                              .publicUserProfileModel.verified!,
                                        ));
                                  }

                                  // ignore: use_build_context_synchronously
                                }

                                // chat = chatWare.chatList
                                //     // ignore: unrelated_type_equality_checks
                                //     .where((element) {
                                //       final val = element.conversations!.last == "kelt"
                                //           ? element.userTwo
                                //           : element.userOne;
                                //       final val2 = data.publicUserProfileModel.username;

                                //       return val == val2;
                                //     })
                                //     .toList()
                                //     .single;

                                // if (chat.conversations!.isNotEmpty) {
                                //   // ignore: use_build_context_synchronously
                                //   PageRouting.pushToPage(context,
                                //       ChatScreen(user: chat, chat: chat.conversations!));
                                // } else {
                                //   // ignore: use_build_context_synchronously
                                //   PageRouting.pushToPage(
                                //       context, ChatScreen(user: chatData, chat: empty));
                                // }

                                emitter("not exist");

                                // PageRouting.pushToPage(
                                //     context, ChatScreen(user: user, chat: chat));
                              },
                              color: "#FFC1D6",
                            ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 50,
                        alignment: Alignment.center,
                        //  color: Colors.amber,
                        child: AppText(
                          text: chatWareStream.loadStatus ? "" : "Message",
                          fontWeight: FontWeight.w400,
                          size: 10,
                          color: HexColor("#797979"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  //   onTap: () => PageRouting.pushToPage(context, const EditProfile()),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ProfileActionButtonNotThisUsers(
                        icon: "assets/icon/email.svg",
                        isSwipe: true,
                        onClick: () async {
                          UserProfileWare data = Provider.of<UserProfileWare>(
                              context,
                              listen: false);
                          if (data.publicUserProfileModel.email == null ||
                              data.publicUserProfileModel.email!.isEmpty) {
                            showToast2(
                                context, "Can't reach this user at the moment",
                                isError: true);
                          } else {
                            final url =
                                'mailTo:${data.publicUserProfileModel.email}?subject=${Uri.encodeFull("From a follower on Macanacki")}&body=${Uri.encodeFull("Sending from my device")}';

                            UrlLaunchController.launchInWebViewOrVC(
                                Uri.parse(url));
                          }
                        },
                        color: "#FFC1D6",
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 70, minWidth: 50),
                        alignment: Alignment.center,
                        // color: Colors.amber,
                        child: AppText(
                          text: "Email",
                          fontWeight: FontWeight.w400,
                          size: 10,
                          color: HexColor("#797979"),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await followAction(context, data.publicUserProfileModel.id!,
                        data.publicUserProfileModel.username!);
                  },
                  child: AnimatedContainer(
                    duration: Duration(seconds: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ProfileActionButtonNotThisUsers(
                          icon: "assets/icon/follow.svg",
                          isSwipe: false,
                          onClick: () async {
                            await followAction(
                              context,
                              data.publicUserProfileModel.id!,
                              data.publicUserProfileModel.username!,
                            );
                          },
                          color: !stream.followIds
                                  .contains(data.publicUserProfileModel.id)
                              ? "#F94C84"
                              : "#FFC1D6",
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        AnimatedContainer(
                          constraints:
                              BoxConstraints(maxWidth: 70, minWidth: 50),
                          alignment: Alignment.center,
                          //color: Colors.amber,
                          duration: Duration(seconds: 2),

                          child: !stream.followIds
                                  .contains(data.publicUserProfileModel.id)
                              ? AppText(
                                  text: "Follow",
                                  fontWeight: FontWeight.w400,
                                  size: 10,
                                  color: HexColor("#797979"),
                                )
                              : AppText(
                                  text: "Unfollow",
                                  fontWeight: FontWeight.w400,
                                  size: 10,
                                  color: HexColor("#797979"),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // const SizedBox(
                      //   height: 4,
                      // ),
                      chatWareStream.loadStatus
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Loader(color: HexColor(primaryColor)),
                            )
                          : ProfileActionButtonNotThisUsers(
                              isSwipe: false,
                              icon: "assets/icon/userchat.svg",
                              onClick: () async {
                                ChatWare chatWare = Provider.of<ChatWare>(
                                    context,
                                    listen: false);
                                await ChatController.retrievChatController(
                                    context, true, false);
                                late ChatData chat;

                                List<Conversation> empty = [];

                                late int statusId;
                                late int id;
                                late ChatData chatData;

                                if (chatWare.chatList.isEmpty) {
                                  statusId = 0;

                                  id = 0;

                                  chatData = ChatData(
                                    status: statusId,
                                    id: id,
                                    userOne: data.userProfileModel.username,
                                    userOneProfilePhoto:
                                        data.userProfileModel.profilephoto,
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                    blockedBy: null,
                                    userTwo:
                                        data.publicUserProfileModel.username,
                                    userTwoProfilePhoto: data
                                        .publicUserProfileModel.profilephoto,
                                    conversations: empty,
                                  );
                                } else {
                                  statusId =
                                      chatWare.chatList.first.status! + 1;

                                  id = chatWare.chatList.first.id! + 1;

                                  chatData = ChatData(
                                    status: statusId,
                                    id: id,
                                    userOne: data.userProfileModel.username,
                                    userOneProfilePhoto:
                                        data.userProfileModel.profilephoto,
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                    blockedBy: null,
                                    userTwo:
                                        data.publicUserProfileModel.username,
                                    userTwoProfilePhoto: data
                                        .publicUserProfileModel.profilephoto,
                                    conversations: empty,
                                  );
                                }

                                bool seen = false;

                                await Future.forEach(chatWare.chatList,
                                    (element) async {
                                  // ignore: unrelated_type_equality_checks
                                  if (element.userTwo ==
                                      data.publicUserProfileModel.username) {
                                    seen = true;
                                    chat = element;
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: element,
                                          chat: element.conversations!,
                                          dp: data.publicUserProfileModel
                                              .profilephoto,
                                          mode:
                                              data.publicUserProfileModel.mode,
                                          isHome: false,
                                          verified: data
                                              .publicUserProfileModel.verified!,
                                        ));
                                    return;
                                  } else if (element.userOne ==
                                      data.publicUserProfileModel.username) {
                                    chat = element;
                                    seen = true;
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: element,
                                          chat: element.conversations!,
                                          dp: data.publicUserProfileModel
                                              .profilephoto,
                                          mode: data.publicUserProfileModel
                                              .profilephoto,
                                          isHome: false,
                                          verified: data
                                              .publicUserProfileModel.verified!,
                                        ));
                                    return;
                                  } else {
                                    chat = ChatData();
                                  }
                                });

                                if (seen) {
                                  return;
                                  // ignore: use_build_context_synchronously
                                } else {
                                  List<ChatData> checker = chatWareStream
                                      .chatList2
                                      .where((element) =>
                                          element.userTwo ==
                                          data.publicUserProfileModel.username)
                                      .toList();
                                  List<ChatData> checker2 = chatWareStream
                                      .chatList2
                                      .where((element) =>
                                          element.userOne ==
                                          data.publicUserProfileModel.username)
                                      .toList();
                                  if (checker.isNotEmpty && checker2.isEmpty) {
                                    // ignore: use_build_context_synchronously
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: checker.first,
                                          chat: checker.first.conversations!,
                                          dp: data.publicUserProfileModel
                                              .profilephoto,
                                          mode:
                                              data.publicUserProfileModel.mode,
                                          isHome: false,
                                          verified: data
                                              .publicUserProfileModel.verified!,
                                        ));
                                  } else if (checker.isEmpty &&
                                      checker2.isNotEmpty) {
                                    // ignore: use_build_context_synchronously
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: checker2.first,
                                          chat: checker2.first.conversations!,
                                          dp: data.publicUserProfileModel
                                              .profilephoto,
                                          mode:
                                              data.publicUserProfileModel.mode,
                                          isHome: false,
                                          verified: data
                                              .publicUserProfileModel.verified!,
                                        ));
                                  } else {
                                    // ignore: use_build_context_synchronously

                                    // ignore: use_build_context_synchronously
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: chatData,
                                          chat: empty,
                                          dp: data.publicUserProfileModel
                                              .profilephoto,
                                          mode:
                                              data.publicUserProfileModel.mode,
                                          isHome: false,
                                          verified: data
                                              .publicUserProfileModel.verified!,
                                        ));
                                  }

                                  // ignore: use_build_context_synchronously
                                }

                                // chat = chatWare.chatList
                                //     // ignore: unrelated_type_equality_checks
                                //     .where((element) {
                                //       final val = element.conversations!.last == "kelt"
                                //           ? element.userTwo
                                //           : element.userOne;
                                //       final val2 = data.publicUserProfileModel.username;

                                //       return val == val2;
                                //     })
                                //     .toList()
                                //     .single;

                                // if (chat.conversations!.isNotEmpty) {
                                //   // ignore: use_build_context_synchronously
                                //   PageRouting.pushToPage(context,
                                //       ChatScreen(user: chat, chat: chat.conversations!));
                                // } else {
                                //   // ignore: use_build_context_synchronously
                                //   PageRouting.pushToPage(
                                //       context, ChatScreen(user: chatData, chat: empty));
                                // }

                                // PageRouting.pushToPage(
                                //     context, ChatScreen(user: user, chat: chat));
                              },
                              color: "#FFC1D6",
                            ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 70, minWidth: 50),
                        alignment: Alignment.center,
                        //color: Colors.amber,
                        child: AppText(
                          text: chatWareStream.loadStatus ? "" : "Message",
                          fontWeight: FontWeight.w400,
                          size: 10,
                          color: HexColor("#797979"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> followAction(
      BuildContext context, int id, String username) async {
    ActionWare provide = Provider.of<ActionWare>(context, listen: false);

    //provide.addFollowId(id);
    await ActionController.followOrUnFollowController(context, username, id);
  }
}

class UserProfileActionsTest extends StatelessWidget {
  PublicUserData data;
  UserProfileActionsTest({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.width;
    ActionWare stream = context.watch<ActionWare>();

    ChatWare chatWareStream = context.watch<ChatWare>();

    return Container(
      width: 220,
      height: 80,
      //  color: Colors.amber,
      child: data.gender == "Business"
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                data.gender == "Business"
                    ? InkWell(
                        //   onTap: () => PageRouting.pushToPage(context, const EditProfile()),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ProfileActionButtonNotThisUsers(
                              icon: "assets/icon/call.svg",
                              isSwipe: false,
                              onClick: () async {
                                UserProfileWare data =
                                    Provider.of<UserProfileWare>(context,
                                        listen: false);
                                if (data.publicUserProfileModel.phone == null) {
                                  showToast2(context,
                                      "Can't reach this Business at the moment",
                                      isError: true);
                                } else {
                                  UrlLaunchController.makePhoneCall(
                                      data.publicUserProfileModel.phone ?? "");
                                }
                              },
                              color: "#FFC1D6",
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: 50,
                              alignment: Alignment.center,
                              // color: Colors.amber,
                              child: AppText(
                                text: "Call",
                                fontWeight: FontWeight.w400,
                                size: 10,
                                color: HexColor("#797979"),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                InkWell(
                  onTap: () async {
                    //   print("dfdd");
                    await followAction(context, data.id!, data.username!);
                  },
                  child: AnimatedContainer(
                    duration: Duration(seconds: 2),
                    child: Column(
                      mainAxisAlignment: data.gender == "Business"
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.center,
                      children: [
                        ProfileActionButtonNotThisUsers(
                          icon: "assets/icon/follow.svg",
                          isSwipe: false,
                          onClick: () async {
                            await followAction(
                              context,
                              data.id!,
                              data.username!,
                            );
                          },
                          color: !stream.followIds.contains(data.id)
                              ? "#F94C84"
                              : "#FFC1D6",
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        AnimatedContainer(
                          width: 50,
                          alignment: Alignment.center,
                          //color: Colors.amber,
                          duration: Duration(seconds: 2),

                          child: !stream.followIds.contains(data.id)
                              ? AppText(
                                  text: "Follow",
                                  fontWeight: FontWeight.w400,
                                  size: 10,
                                  color: HexColor("#797979"),
                                )
                              : AppText(
                                  text: "Unfollow",
                                  fontWeight: FontWeight.w400,
                                  size: 10,
                                  color: HexColor("#797979"),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 4,
                      ),
                      chatWareStream.loadStatus
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Loader(color: HexColor(primaryColor)),
                            )
                          : ProfileActionButtonNotThisUsers(
                              isSwipe: false,
                              icon: "assets/icon/userchat.svg",
                              onClick: () async {
                                late ChatData chat;
                                ChatWare chatWare = Provider.of<ChatWare>(
                                    context,
                                    listen: false);
                                await ChatController.retrievChatController(
                                    context, true, false);
                                List<Conversation> empty = [];

                                late int statusId;
                                late int id;
                                late ChatData chatData;

                                if (chatWare.chatList.isEmpty) {
                                  statusId = 0;

                                  id = 0;

                                  chatData = ChatData(
                                    status: statusId,
                                    id: id,
                                    userOne: data.username,
                                    userOneProfilePhoto: data.profilephoto,
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                    blockedBy: null,
                                    userTwo: data.username,
                                    userTwoProfilePhoto: data.profilephoto,
                                    conversations: empty,
                                  );
                                } else {
                                  statusId =
                                      chatWare.chatList.first.status! + 1;

                                  id = chatWare.chatList.first.id! + 1;

                                  chatData = ChatData(
                                    status: statusId,
                                    id: id,
                                    userOne: data.username,
                                    userOneProfilePhoto: data.profilephoto,
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                    blockedBy: null,
                                    userTwo: data.username,
                                    userTwoProfilePhoto: data.profilephoto,
                                    conversations: empty,
                                  );
                                }

                                bool seen = false;

                                await Future.forEach(chatWare.chatList,
                                    (element) async {
                                  // ignore: unrelated_type_equality_checks
                                  if (element.userTwo == data.username) {
                                    seen = true;
                                    chat = element;
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: element,
                                          chat: element.conversations!,
                                          dp: data.profilephoto,
                                          mode: data.mode,
                                          isHome: false,
                                          verified: data.verified!,
                                        ));
                                    return;
                                  } else if (element.userOne == data.username) {
                                    chat = element;
                                    seen = true;
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: element,
                                          chat: element.conversations!,
                                          dp: data.profilephoto,
                                          mode: data.profilephoto,
                                          isHome: false,
                                          verified: data.verified!,
                                        ));
                                    return;
                                  } else {
                                    chat = ChatData();
                                  }
                                });

                                if (seen) {
                                  return;
                                  // ignore: use_build_context_synchronously
                                } else {
                                  List<ChatData> checker = chatWareStream
                                      .chatList2
                                      .where((element) =>
                                          element.userTwo == data.username)
                                      .toList();
                                  List<ChatData> checker2 = chatWareStream
                                      .chatList2
                                      .where((element) =>
                                          element.userOne == data.username)
                                      .toList();
                                  if (checker.isNotEmpty && checker2.isEmpty) {
                                    // ignore: use_build_context_synchronously
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: checker.first,
                                          chat: checker.first.conversations!,
                                          dp: data.profilephoto,
                                          mode: data.mode,
                                          isHome: false,
                                          verified: data.verified!,
                                        ));
                                  } else if (checker.isEmpty &&
                                      checker2.isNotEmpty) {
                                    // ignore: use_build_context_synchronously
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: checker2.first,
                                          chat: checker2.first.conversations!,
                                          dp: data.profilephoto,
                                          mode: data.mode,
                                          isHome: false,
                                          verified: data.verified!,
                                        ));
                                  } else {
                                    // ignore: use_build_context_synchronously

                                    // ignore: use_build_context_synchronously
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: chatData,
                                          chat: empty,
                                          dp: data.profilephoto,
                                          mode: data.mode,
                                          isHome: false,
                                          verified: data.verified!,
                                        ));
                                  }

                                  // ignore: use_build_context_synchronously
                                }

                                emitter("not exist");

                                // PageRouting.pushToPage(
                                //     context, ChatScreen(user: user, chat: chat));
                              },
                              color: "#FFC1D6",
                            ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 50,
                        alignment: Alignment.center,
                        //  color: Colors.amber,
                        child: AppText(
                          text: chatWareStream.loadStatus ? "" : "Message",
                          fontWeight: FontWeight.w400,
                          size: 10,
                          color: HexColor("#797979"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  //   onTap: () => PageRouting.pushToPage(context, const EditProfile()),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ProfileActionButtonNotThisUsers(
                        icon: "assets/icon/email.svg",
                        isSwipe: true,
                        onClick: () async {
                          UserProfileWare data = Provider.of<UserProfileWare>(
                              context,
                              listen: false);
                          if (data.publicUserProfileModel.email == null ||
                              data.publicUserProfileModel.email!.isEmpty) {
                            showToast2(
                                context, "Can't reach this user at the moment",
                                isError: true);
                          } else {
                            final url =
                                'mailTo:${data.publicUserProfileModel.email}?subject=${Uri.encodeFull("From a follower on Macanacki")}&body=${Uri.encodeFull("Sending from my device")}';

                            UrlLaunchController.launchInWebViewOrVC(
                                Uri.parse(url));
                          }
                        },
                        color: "#FFC1D6",
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 70, minWidth: 50),
                        alignment: Alignment.center,
                        // color: Colors.amber,
                        child: AppText(
                          text: "Email",
                          fontWeight: FontWeight.w400,
                          size: 10,
                          color: HexColor("#797979"),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await followAction(context, data.id!, data.username!);
                  },
                  child: AnimatedContainer(
                    duration: Duration(seconds: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ProfileActionButtonNotThisUsers(
                          icon: "assets/icon/follow.svg",
                          isSwipe: false,
                          onClick: () async {
                            await followAction(
                              context,
                              data.id!,
                              data.username!,
                            );
                          },
                          color: !stream.followIds.contains(data.id)
                              ? "#F94C84"
                              : "#FFC1D6",
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        AnimatedContainer(
                          constraints:
                              BoxConstraints(maxWidth: 70, minWidth: 50),
                          alignment: Alignment.center,
                          //color: Colors.amber,
                          duration: Duration(seconds: 2),

                          child: !stream.followIds.contains(data.id)
                              ? AppText(
                                  text: "Follow",
                                  fontWeight: FontWeight.w400,
                                  size: 10,
                                  color: HexColor("#797979"),
                                )
                              : AppText(
                                  text: "Unfollow",
                                  fontWeight: FontWeight.w400,
                                  size: 10,
                                  color: HexColor("#797979"),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // const SizedBox(
                      //   height: 4,
                      // ),
                      chatWareStream.loadStatus
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Loader(color: HexColor(primaryColor)),
                            )
                          : ProfileActionButtonNotThisUsers(
                              isSwipe: false,
                              icon: "assets/icon/userchat.svg",
                              onClick: () async {
                                ChatWare chatWare = Provider.of<ChatWare>(
                                    context,
                                    listen: false);
                                await ChatController.retrievChatController(
                                    context, true, false);
                                late ChatData chat;

                                List<Conversation> empty = [];

                                late int statusId;
                                late int id;
                                late ChatData chatData;

                                if (chatWare.chatList.isEmpty) {
                                  statusId = 0;

                                  id = 0;

                                  chatData = ChatData(
                                    status: statusId,
                                    id: id,
                                    userOne: data.username,
                                    userOneProfilePhoto: data.profilephoto,
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                    blockedBy: null,
                                    userTwo: data.username,
                                    userTwoProfilePhoto: data.profilephoto,
                                    conversations: empty,
                                  );
                                } else {
                                  statusId =
                                      chatWare.chatList.first.status! + 1;

                                  id = chatWare.chatList.first.id! + 1;

                                  chatData = ChatData(
                                    status: statusId,
                                    id: id,
                                    userOne: data.username,
                                    userOneProfilePhoto: data.profilephoto,
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                    blockedBy: null,
                                    userTwo: data.username,
                                    userTwoProfilePhoto: data.profilephoto,
                                    conversations: empty,
                                  );
                                }

                                bool seen = false;

                                await Future.forEach(chatWare.chatList,
                                    (element) async {
                                  // ignore: unrelated_type_equality_checks
                                  if (element.userTwo == data.username) {
                                    seen = true;
                                    chat = element;
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: element,
                                          chat: element.conversations!,
                                          dp: data.profilephoto,
                                          mode: data.mode,
                                          isHome: false,
                                          verified: data.verified!,
                                        ));
                                    return;
                                  } else if (element.userOne == data.username) {
                                    chat = element;
                                    seen = true;
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: element,
                                          chat: element.conversations!,
                                          dp: data.profilephoto,
                                          mode: data.profilephoto,
                                          isHome: false,
                                          verified: data.verified!,
                                        ));
                                    return;
                                  } else {
                                    chat = ChatData();
                                  }
                                });

                                if (seen) {
                                  return;
                                  // ignore: use_build_context_synchronously
                                } else {
                                  List<ChatData> checker = chatWareStream
                                      .chatList2
                                      .where((element) =>
                                          element.userTwo == data.username)
                                      .toList();
                                  List<ChatData> checker2 = chatWareStream
                                      .chatList2
                                      .where((element) =>
                                          element.userOne == data.username)
                                      .toList();
                                  if (checker.isNotEmpty && checker2.isEmpty) {
                                    // ignore: use_build_context_synchronously
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: checker.first,
                                          chat: checker.first.conversations!,
                                          dp: data.profilephoto,
                                          mode: data.mode,
                                          isHome: false,
                                          verified: data.verified!,
                                        ));
                                  } else if (checker.isEmpty &&
                                      checker2.isNotEmpty) {
                                    // ignore: use_build_context_synchronously
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: checker2.first,
                                          chat: checker2.first.conversations!,
                                          dp: data.profilephoto,
                                          mode: data.mode,
                                          isHome: false,
                                          verified: data.verified!,
                                        ));
                                  } else {
                                    // ignore: use_build_context_synchronously

                                    // ignore: use_build_context_synchronously
                                    PageRouting.pushToPage(
                                        context,
                                        ChatScreen(
                                          user: chatData,
                                          chat: empty,
                                          dp: data.profilephoto,
                                          mode: data.mode,
                                          isHome: false,
                                          verified: data.verified!,
                                        ));
                                  }

                                  // ignore: use_build_context_synchronously
                                }
                              },
                              color: "#FFC1D6",
                            ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 70, minWidth: 50),
                        alignment: Alignment.center,
                        //color: Colors.amber,
                        child: AppText(
                          text: chatWareStream.loadStatus ? "" : "Message",
                          fontWeight: FontWeight.w400,
                          size: 10,
                          color: HexColor("#797979"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> followAction(
      BuildContext context, int id, String username) async {
    ActionWare provide = Provider.of<ActionWare>(context, listen: false);

    //provide.addFollowId(id);
    await ActionController.followOrUnFollowController(context, username, id);
  }
}
