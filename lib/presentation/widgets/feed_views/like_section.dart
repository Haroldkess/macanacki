import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:like_button/like_button.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/presentation/widgets/option_modal.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import '../../../model/asset_data.dart';
import '../../../model/feed_post_model.dart';
import '../../../services/backoffice/mux_client.dart';
import '../../../services/controllers/action_controller.dart';
import '../../../services/controllers/save_media_controller.dart';
import '../../../services/middleware/action_ware.dart';
import '../../../services/middleware/gift_ware.dart';
import '../../../services/middleware/user_profile_ware.dart';
import '../../constants/colors.dart';
import '../../operations.dart';
import '../../screens/home/diamond/diamond_modal/download_modal.dart';
import '../../screens/home/diamond/diamond_modal/give_modal.dart';
import '../../uiproviders/screen/comment_provider.dart';
import '../comment_modal.dart';
import '../text.dart';

class LikeSection extends StatefulWidget {
  final FeedPost data;
  String page;
  bool? isAudio;
  String? userName;
  bool? isHome;
  bool showComment;
  dynamic mediaController;

  // final List<String> media;
  // final List<String> urls;
  LikeSection({
    super.key,
    required this.data,
    required this.page,
    required this.isHome,
    this.isAudio,
    this.userName,
    required this.showComment,
    required this.mediaController,
    // required this.media,
    // required this.urls
  });

  @override
  State<LikeSection> createState() => _LikeSectionState();
}

class _LikeSectionState extends State<LikeSection> {
  @override
  Widget build(BuildContext context) {
    ActionWare stream = context.watch<ActionWare>();
    StoreComment comment = context.watch<StoreComment>();
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(
        right: 10,
      ),
      child: Container(
        height: 200,
        width: 70,
        color: Colors.transparent,
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            likeButton(
                context,
                stream.likeIds.contains(widget.data.id!) ||
                        stream.isDoubleTapped
                    ? widget.data.noOfLikes! + stream.addLike
                    : widget.data.noOfLikes!,
                stream.likeIds.contains(widget.data.id!) ||
                        stream.isDoubleTapped
                    ? true
                    : false),
            // myIcon("assets/icon/heart.svg", backgroundColor, 35, 35,
            //     widget.data.noOfLikes),
            InkWell(
              onTap: () async {
                StoreComment comment =
                    Provider.of<StoreComment>(context, listen: false);
                List checkCom = comment.comments
                    .where((element) => element.postId == widget.data.id)
                    .toList();

                if (checkCom.isEmpty) {
                  if (widget.data.comments!.isEmpty) {
                  } else {
                    Operations.commentOperation(
                        context, false, widget.data.comments!);
                  }
                } else {}
                setState(() {});
                //   emitter(comment.comments.length.toString());
                // emitter(widget.data.id!.toString());
                // Operations.commentOperation(
                //     context, false, widget.data.comments!);

                commentModal(
                    context,
                    widget.data.id!,
                    widget.page,
                    widget.isHome ?? false,
                    true,
                    widget.mediaController,
                    widget.data.comments);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: myIcon(
                    "assets/icon/coment.svg",
                    backgroundColor,
                    20,
                    20,
                    comment.comments
                        .where((element) => element.postId == widget.data.id)
                        .toList()
                        .length),
              ),
            ),

            widget.data.user!.username! == user.userProfileModel.username
                ? InkWell(
                    onTap: () async {
                      if (widget.data.media == null) return;
                      if (widget.data.user!.username! ==
                          user.userProfileModel.username) {
                        if (widget.data.media!.length > 1) {
                          await Future.forEach(widget.data.media!,
                              (element) async {
                            if (element.isNotEmpty) {
                              try {
                                if (element.contains('.mp4')) {
                                  await SaveMediaController.saveNetworkVideo(
                                      context, element, "macanacki");
                                } else if (element.contains('.mp3')) {
                                  // await SaveMediaController.saveNetworkAudio(
                                  //     context, element, "macanacki");
                                } else {
                                  await SaveMediaController.saveNetworkImage(
                                      context, element, "macanacki");
                                }
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                            }
                          });
                        } else {
                          if (widget.data.media!.first.contains('.mp4')) {
                            await SaveMediaController.saveNetworkVideo(
                                context,
                                widget.data.media!.first,
                                widget.data.description ?? "macanacki");
                          } else if (widget.data.media!.first
                              .contains('.mp3')) {
                            await SaveMediaController.saveNetworkAudio(
                                context,
                                widget.data.media!.first,
                                widget.data.description ?? "macanacki");
                          } else {
                            await SaveMediaController.saveNetworkImage(
                                context,
                                widget.data.media!.first,
                                widget.data.description ?? "macanacki");
                          }
                        }
                      } else {
                        downloadDiamondsModal(
                          context,
                          widget.data.id!,
                        );
                      }

                      //  GiftWare.instance.giftForDownloadFromApi(
                      //             widget.data.id!, context);
                    },
                    child: widget.data.media!.first.contains(".mp3")
                        ? SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(right: 3.0),
                            child: myIcon("assets/icon/d.svg", backgroundColor,
                                20, 20, null),
                          ),
                  )
                : InkWell(
                    onTap: () async {
                      giveDiamondsModal(context, widget.data.user!.username!);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 3.0),
                      child:
                          myIcon("assets/icon/diamond.svg", null, 20, 20, null),
                    ),
                  ),

            // Martins was here
            // widget.data.user!.username! == user.userProfileModel.username ||
            //         widget.data.media!.first.contains(".mp3")
            //     ? SizedBox.shrink()
            //     : InkWell(
            //         onTap: () async {
            //           if (widget.data.media == null) return;
            //           if (widget.data.user!.username! ==
            //               user.userProfileModel.username) {
            //             if (widget.data.media!.length > 1) {
            //               await Future.forEach(widget.data.media!,
            //                   (element) async {
            //                 if (element.isNotEmpty) {
            //                   try {
            //                     if (element.contains('.mp4')) {
            //                       await SaveMediaController.saveNetworkVideo(
            //                           context, element, "macanacki");
            //                     } else if (element.contains('.mp3')) {
            //                       await SaveMediaController.saveNetworkAudio(
            //                           context, element, "macanacki");
            //                     } else {
            //                       await SaveMediaController.saveNetworkImage(
            //                           context, element, "macanacki");
            //                     }
            //                   } catch (e) {
            //                     debugPrint(e.toString());
            //                   }
            //                 }
            //               });
            //             } else {
            //               if (widget.data.media!.first.contains('.mp4')) {
            //                 await SaveMediaController.saveNetworkVideo(
            //                     context,
            //                     widget.data.media!.first,
            //                     widget.data.description ?? "macanacki");
            //               } else if (widget.data.media!.first
            //                   .contains('.mp3')) {
            //                 await SaveMediaController.saveNetworkAudio(
            //                     context,
            //                     widget.data.media!.first,
            //                     widget.data.description ?? "macanacki");
            //               } else {
            //                 await SaveMediaController.saveNetworkImage(
            //                     context,
            //                     widget.data.media!.first,
            //                     widget.data.description ?? "macanacki");
            //               }
            //             }
            //           } else {
            //             downloadDiamondsModal(
            //                 context, widget.data.id!, widget.isAudio);
            //           }
            //
            //           //  GiftWare.instance.giftForDownloadFromApi(
            //           //             widget.data.id!, context);
            //         },
            //         child: Padding(
            //           padding: const EdgeInsets.only(right: 3.0),
            //           child: myIcon(
            //               "assets/icon/d.svg", backgroundColor, 20, 20, null),
            //         ),
            //       ),

            // InkWell(
            //     onTap: () => optionModal(
            //         context, widget.urls, widget.data.user!.id, widget.data.id),
            //     child: myIcon(
            //       "assets/icon/more.svg",
            //       backgroundColor,
            //       30,
            //       30,
            //     )),
          ],
        ),
      ),
    );
  }

  Column myIcon(String svgPath, String? hexString, double height, double width,
      [int? text]) {
    StoreComment comment = context.watch<StoreComment>();
    return Column(
      children: [
        InkWell(
          child: SvgPicture.asset(
            svgPath,
            height: height,
            width: width,
            color: hexString == null ? null : textWhite,
          ),
        ),
        text == null
            ? SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: AppText(
                  text: text == null
                      ? ""
                      : Numeral(text == 0 ? widget.data.comments!.length : text)
                          .format(fractionDigits: 1),
                  size: 16,
                  align: TextAlign.center,
                  fontWeight: FontWeight.w700,
                  color: textWhite,
                ),
              )
      ],
    );
  }

  Column likeButton(BuildContext context, int likes, bool likedBefore) {
    //  ActionWare stream = context.watch<ActionWare>();
    //log(likedBefore.toString());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LikeButton(
          isLiked: likedBefore,
          animationDuration: Duration(seconds: 2),
          circleColor: CircleColor(start: Colors.blue, end: secondaryColor),
          bubblesColor: BubblesColor(
              dotPrimaryColor: Colors.grey,
              dotSecondaryColor: Colors.blue,
              dotThirdColor: Colors.yellow,
              dotLastColor: secondaryColor),
          countPostion: CountPostion.bottom,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          likeCountPadding: EdgeInsets.only(top: 5, left: 40),
          onTap: (isLiked) async {
            HapticFeedback.heavyImpact();

            likeAction(context, isLiked);
            return !isLiked;
          },
          countDecoration: (count, likeCount) => Align(
            alignment: Alignment.centerRight,
            child: Center(
              child: AppText(
                text: Numeral(likeCount!).format(),
                color: Colors.white,
                align: TextAlign.center,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          padding: EdgeInsets.only(left: 7),
          likeCount: int.tryParse(Numeral(likes).format()),
          likeBuilder: (bool isLiked) {
            return isLiked
                ? Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Icon(
                      Icons.favorite,
                      color: secondaryColor,
                      size: 25,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(left: 7),
                    child: Container(
                      height: 10,
                      width: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: SvgPicture.asset(
                          "assets/icon/hert.svg",
                          color: textWhite,
                          height: 10,
                          width: 10,
                        ),
                      ),
                    ),
                  );
          },
        ),
      ],
    );
  }

  Future<void> likeAction(BuildContext context, bool like) async {
    ActionWare provide = Provider.of<ActionWare>(context, listen: false);
    late bool isLiked;
    // print(like.toString());
    provide.tempAddLikeId(widget.data.id!);

    if (like == false) {
      isLiked = true;
      ActionController.likeOrDislikeController(context, widget.data.id!);
    } else {
      //  provide.tempAddLikeId(widget.data.id!);
      isLiked = false;
      ActionController.likeOrDislikeController(context, widget.data.id!);
    }

    // return !isLiked;
  }
}
