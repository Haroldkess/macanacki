// import 'dart:developer';
// import 'dart:ui';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:like_button/like_button.dart';
// import 'package:lottie/lottie.dart';
// import 'package:makanaki/presentation/allNavigation.dart';
// import 'package:makanaki/presentation/constants/colors.dart';
// import 'package:makanaki/presentation/constants/params.dart';
// import 'package:makanaki/presentation/operations.dart';
// import 'package:makanaki/presentation/screens/home/Feed/feed_video_holder.dart';
// import 'package:makanaki/presentation/screens/userprofile/user_profile_screen.dart';
// import 'package:makanaki/presentation/uiproviders/screen/comment_provider.dart';
// import 'package:makanaki/presentation/widgets/comment_modal.dart';
// import 'package:makanaki/presentation/widgets/hexagon_avatar.dart';
// import 'package:makanaki/presentation/widgets/option_modal.dart';
// import 'package:makanaki/presentation/widgets/text.dart';
// import 'package:makanaki/services/controllers/action_controller.dart';
// import 'package:makanaki/services/middleware/action_ware.dart';
// import 'package:makanaki/services/temps/temps_id.dart';
// import 'package:numeral/numeral.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:video_player/video_player.dart';

// import '../../../../../../model/feed_post_model.dart';
// import '../../../../../../model/public_profile_model.dart';
// import '../../../../../uiproviders/screen/tab_provider.dart';

// class PublicUserFeedView extends StatefulWidget {
//   final String media;
//   final PublicUserPost data;
//   int? index1;
//   int? index2;
//   final int userId;
//   PublicUserFeedView(
//       {super.key,
//       required this.media,
//       required this.data,
//       this.index1,
//       this.index2,
//       required this.userId});

//   @override
//   State<PublicUserFeedView> createState() => _PublicUserFeedViewState();
// }

// class _PublicUserFeedViewState extends State<PublicUserFeedView>
//     with SingleTickerProviderStateMixin {
//   String test =
//       "dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd";

//   bool showMore = false;
//   late SharedPreferences pref;
//   String myUsername = "";
//   bool flag = false;

//   late VideoPlayerController _controller;
//   late AnimationController controller;
//   late Animation animation;

//   @override
//   void initState() {
//     super.initState();
//     SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
//       Operations.commentOperation(context, false, widget.data.comments!);
//     });

//     controller = AnimationController(
//       duration: const Duration(milliseconds: 800), //controll animation duration

//       vsync: this,
//     )..addListener(() {
//         setState(() {});
//       });

//     animation = ColorTween(
//       begin: Colors.transparent,
//       end: HexColor(primaryColor).withOpacity(.8),
//     ).animate(controller);
//     initPref();

//     if (widget.data.media!.contains(".mp4")) {
//       _controller = VideoPlayerController.network(
//         widget.data.media!,
//         //   videoPlayerOptions: VideoPlayerOptions()
//       );

//       _controller.initialize().whenComplete(() {
//         _controller.play();
//         setState(() {});
//       });

//       // Use the controller to loop the video.

//       _controller.setLooping(true);
//     }
//   }

//   initPref() async {
//     pref = await SharedPreferences.getInstance();
//     setState(() {
//       myUsername = pref.getString(userNameKey)!;
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     controller.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     var size = MediaQuery.of(context).size;
//     var padding = 8.0;
//     //_checkIfLikedBefore();
//     var w = (size.width - 4 * 1) / 10;
//     ActionWare stream = context.watch<ActionWare>();
//     ActionWare action = Provider.of<ActionWare>(context, listen: false);
//     StoreComment comment = context.watch<StoreComment>();

//     return GestureDetector(
//       onDoubleTap: () async {
//         if (controller.value == 1) {
//           controller.reset();
//           controller.forward();
//         } else {
//           controller.forward();
//         }
//         if (action.likeIds.contains(widget.data.id!)) {
//           setState(() {
//             flag = true;
//           });
//           await Future.delayed(const Duration(seconds: 2));

//           setState(() {
//             flag = false;
//           });

//           return;
//         }
//         setState(() {
//           flag = true;
//         });

//         await likeAction(context, true);

//         await Future.delayed(const Duration(seconds: 2));

//         setState(() {
//           flag = false;
//         });
//       },
//       child: Stack(
//         children: [
//           Container(
//             width: width,
//             height: height,
//             child: Flex(
//               //   mainAxisSize: MainAxisSize.min,
//               direction: Axis.vertical,
//               // clipBehavior: Clip.hardEdge,
//               children: <Widget>[
//                 Expanded(
//                     child: LayoutBuilder(
//                   builder: (_, constraints) => widget.media.contains(".mp4")
//                       ? FeedVideoHolder(
//                           file: widget.media,
//                           controller: _controller,
//                           shouldPlay: true,
//                         )
//                       : Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             Container(
//                                 width: width,
//                                 height: height,
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                   image: NetworkImage(widget.media),
//                                   fit: BoxFit.fill,
//                                 )),
//                                 child: BackdropFilter(
//                                   filter: ImageFilter.blur(
//                                       sigmaX: 20.0, sigmaY: 20.0),
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         color: Colors.white.withOpacity(0.0)),
//                                   ),
//                                 )),
//                             Image(
//                               //  fit: BoxFit.fitWidth,
//                               width: constraints.maxWidth,
//                               image: NetworkImage(widget.media),
//                             ),
//                           ],
//                         ),
//                 ))
//               ],
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomRight,
//             child: Padding(
//               padding: const EdgeInsets.only(right: 10),
//               child: Container(
//                 height: 300,
//                 width: 70,
//                 color: Colors.transparent,
//                 alignment: Alignment.centerRight,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     likeButton(
//                         context,
//                         stream.likeIds.contains(widget.data.id!) ||
//                                 stream.isDoubleTapped
//                             ? widget.data.noOfLikes! + stream.addLike
//                             : widget.data.noOfLikes!,
//                         stream.likeIds.contains(widget.data.id!) ||
//                                 stream.isDoubleTapped
//                             ? true
//                             : false),
//                     // myIcon("assets/icon/heart.svg", backgroundColor, 35, 35,
//                     //     widget.data.noOfLikes),
//                     InkWell(
//                       onTap: () async {
//                         List<Comment> data = [];
//                         widget.data.comments!.forEach((element) {
//                           Comment tempData = Comment(
//                             id: element.id,
//                             body: element.body,
//                             createdAt: element.createdAt,
//                             updatedAt: element.updatedAt,
//                             username: element.username,
//                             profilePhoto: element.profilePhoto,
//                             noOfLikes: element.noOfLikes,
//                             postId: element.postId,
//                           );

//                           data.add(tempData);
//                         });

//                         Operations.commentOperation(context, false, data);
//                         commentModal(context, widget.data.id!);
//                       },
//                       child: myIcon("assets/icon/comments.svg", backgroundColor,
//                           35, 35, comment.comments.length),
//                     ),
//                     InkWell(
//                         onTap: () => optionModal(context, widget.media),
//                         child: myIcon(
//                           "assets/icon/more.svg",
//                           backgroundColor,
//                           35,
//                           35,
//                         )),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Align(
//               alignment: Alignment.bottomLeft,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 10.0),
//                 child: Container(
//                   height: showMore ? 250 : 90,
//                   width: width * 0.8,
//                   //   color: Colors.amber,
//                   child: Column(
//                     children: [
//                       Container(
//                         // width: width * 0.7,
//                         constraints: BoxConstraints(maxWidth: width * 0.7),
//                         //  color: Colors.black,
//                         child: Row(
//                           // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             HexagonAvatar(
//                               url: widget.data.user!.profilephoto!,
//                               w: w,
//                               onTap: () async {
//                                 if (widget.data.media!.contains(".mp4")) {
//                                   _controller.pause();
//                                 }

//                                 if (widget.data.user!.username! ==
//                                     pref.getString(userNameKey)) {
//                                   // PageRouting.pushToPage(
//                                   //     context, const ProfileScreen());
//                                 } else {
//                                   PageRouting.pushToPage(
//                                       context,
//                                       UsersProfile(
//                                         username: widget.data.user!.username!,
//                                       ));
//                                 }
//                               },
//                             ),
//                             const SizedBox(
//                               width: 5.5,
//                             ),
//                             Container(
//                               constraints:
//                                   BoxConstraints(maxWidth: width * 0.3),
//                               child: AppText(
//                                 text: widget.data.user!.username!,
//                                 fontWeight: FontWeight.w500,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 color: HexColor(backgroundColor),
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 5.5,
//                             ),
//                             // Image.asset("assets/pic/verified.png"),
//                             // const SizedBox(
//                             //   width: 5.5,
//                             // ),
//                             myUsername == widget.data.user!.username!
//                                 ? const SizedBox.shrink()
//                                 : followButton(() async {
//                                     followAction(
//                                       context,
//                                     );
//                                   },
//                                     stream.followIds.contains(widget.userId)
//                                         ? "Unfollow"
//                                         : "Follow"),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 60),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                               //  color: Colors.amber,
//                               //   width: width * 0.5,
//                               constraints:
//                                   BoxConstraints(maxWidth: width * 0.45),
//                               child: AppText(
//                                 text: widget.data.description!,
//                                 color:
//                                     HexColor(backgroundColor).withOpacity(0.9),
//                                 size: 14,
//                                 fontWeight: FontWeight.w400,
//                                 align: TextAlign.start,
//                                 maxLines: showMore ? 50 : 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                             widget.data.description!.length < 50
//                                 ? const SizedBox.shrink()
//                                 : Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       TextButton(
//                                         onPressed: () {
//                                           if (showMore) {
//                                             setState(() {
//                                               showMore = false;
//                                             });
//                                           } else {
//                                             setState(() {
//                                               showMore = true;
//                                             });
//                                           }
//                                         },
//                                         child: AppText(
//                                           text: showMore ? "Less" : "More",
//                                           color: HexColor(backgroundColor),
//                                           size: 14,
//                                           fontWeight: FontWeight.w400,
//                                           align: TextAlign.start,
//                                         ),
//                                       )
//                                     ],
//                                   )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               )),
//           flag
//               ? Align(
//                   alignment: Alignment.center,
//                   child: AnimatedContainer(
//                     duration: Duration(seconds: 3),
//                     curve: Curves.bounceInOut,
//                     onEnd: () {
//                       setState(() {
//                         flag = false;
//                       });
//                     },
//                     child:
//                         // Lottie.asset('assets/icon/like.json',
//                         //     height: MediaQuery.of(context).size.width * 0.5,
//                         //     width: MediaQuery.of(context).size.width * 0.5,
//                         //     repeat: false,
//                         //     fit: BoxFit.fill),
//                         Icon(
//                       Icons.favorite,
//                       size: MediaQuery.of(context).size.width * 0.4,
//                       color: animation.value,
//                     ),
//                   ),
//                 )
//               : const SizedBox.shrink(),
//         ],
//       ),
//     );
//   }

//   Widget followButton(VoidCallback onTap, String title) {
//     //  ActionWare stream = context.watch<ActionWare>();
//     return InkWell(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 500),
//         height: 21,
//         width: title == "Follow" ? 54 : 100,
//         decoration: BoxDecoration(
//             shape: BoxShape.rectangle,
//             border: Border.all(
//                 color: title == "Follow"
//                     ? HexColor("#8B8B8B").withOpacity(0.9)
//                     : HexColor(backgroundColor).withOpacity(0.7)),
//             borderRadius: BorderRadius.circular(5)),
//         child: Center(
//           child: AppText(
//             text: title,
//             color: HexColor(backgroundColor),
//           ),
//         ),
//       ),
//     );
//   }

//   Column myIcon(String svgPath, String hexString, double height, double width,
//       [int? text]) {
//     return Column(
//       children: [
//         InkWell(
//           child: SvgPicture.asset(
//             svgPath,
//             height: height,
//             width: width,
//             color: HexColor(hexString),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8.0),
//           child: AppText(
//             text: text == null ? "" : Numeral(text).format(),
//             size: 16,
//             align: TextAlign.center,
//             fontWeight: FontWeight.w400,
//             color: HexColor(backgroundColor),
//           ),
//         )
//       ],
//     );
//   }

//   Column likeButton(BuildContext context, int likes, bool likedBefore) {
//     //  ActionWare stream = context.watch<ActionWare>();
//     //log(likedBefore.toString());
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         LikeButton(
//           isLiked: likedBefore,
//           circleColor:
//               CircleColor(start: HexColor(primaryColor), end: Colors.red),
//           bubblesColor: BubblesColor(
//               dotPrimaryColor: Colors.red,
//               dotSecondaryColor: HexColor(primaryColor),
//               dotThirdColor: Colors.yellow,
//               dotLastColor: Colors.green),
//           countPostion: CountPostion.bottom,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           mainAxisAlignment: MainAxisAlignment.end,
//           likeCountPadding: EdgeInsets.only(top: 10, left: 36),
//           onTap: (isLiked) async {
//             likeAction(context, isLiked);
//             return !isLiked;
//           },
//           countDecoration: (count, likeCount) => Align(
//             alignment: Alignment.centerRight,
//             child: Center(
//               child: AppText(
//                 text: Numeral(likeCount!).format(),
//                 color: Colors.white,
//                 align: TextAlign.center,
//               ),
//             ),
//           ),
//           padding: EdgeInsets.only(right: 5),
//           likeCount: int.tryParse(Numeral(likes).format()),
//           likeBuilder: (bool isLiked) {
//             return Center(
//               child: isLiked
//                   ? Icon(
//                       Icons.favorite,
//                       color: HexColor(primaryColor),
//                       size: 35,
//                     )
//                   : SvgPicture.asset(
//                       "assets/icon/heart.svg",
//                       color: HexColor(backgroundColor),
//                       height: 45,
//                       width: 45,
//                     ),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Future<void> followAction(BuildContext context) async {
//     ActionWare provide = Provider.of<ActionWare>(context, listen: false);

//     //  provide.addFollowId(widget.userId);
//     await ActionController.followOrUnFollowController(
//         context, widget.data.user!.username!, widget.data.id!);
//   }

//   Future<void> likeAction(BuildContext context, bool like) async {
//     ActionWare provide = Provider.of<ActionWare>(context, listen: false);
//     late bool isLiked;
//     print(like.toString());
//     provide.tempAddLikeId(widget.data.id!);
//     if (like == false) {
//       isLiked = true;
//       ActionController.likeOrDislikeController(context, widget.data.id!);
//     } else {
//       isLiked = false;
//       ActionController.likeOrDislikeController(context, widget.data.id!);
//     }

//     //  return !isLiked;
//   }
// }
