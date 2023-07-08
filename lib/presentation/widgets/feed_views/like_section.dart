import 'dart:convert';

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
import '../../../services/middleware/action_ware.dart';
import '../../constants/colors.dart';
import '../../operations.dart';
import '../../uiproviders/screen/comment_provider.dart';
import '../comment_modal.dart';
import '../text.dart';

class LikeSection extends StatefulWidget {
  final FeedPost data;
  String page;
  final List<String> media;
  final List<String> urls;
  LikeSection(
      {super.key,
      required this.data,
      required this.page,
      required this.media,
      required this.urls});

  @override
  State<LikeSection> createState() => _LikeSectionState();
}

class _LikeSectionState extends State<LikeSection> {
  @override
  Widget build(BuildContext context) {
    ActionWare stream = context.watch<ActionWare>();
    StoreComment comment = context.watch<StoreComment>();
    return Padding(
      padding: const EdgeInsets.only(
        right: 10,
      ),
      child: Container(
        height: 300,
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

                commentModal(context, widget.data.id!, widget.page);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: myIcon(
                    "assets/icon/tick_comment.svg",
                    backgroundColor,
                    30,
                    30,
                    comment.comments
                        .where((element) => element.postId == widget.data.id)
                        .toList()
                        .length),
              ),
            ),

            InkWell(
                onTap: () => optionModal(
                    context, widget.urls, widget.data.user!.id, widget.data.id),
                child: myIcon(
                  "assets/icon/more.svg",
                  backgroundColor,
                  30,
                  30,
                )),
          ],
        ),
      ),
    );
  }

  Column myIcon(String svgPath, String hexString, double height, double width,
      [int? text]) {
    StoreComment comment = context.watch<StoreComment>();
    return Column(
      children: [
        InkWell(
          child: SvgPicture.asset(
            svgPath,
            height: height,
            width: width,
            color: HexColor(hexString),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: AppText(
            text: text == null
                ? ""
                : Numeral(text == 0 ? widget.data.comments!.length : text)
                    .format(),
            size: 16,
            align: TextAlign.center,
            fontWeight: FontWeight.w400,
            color: HexColor(backgroundColor),
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
          circleColor:
              CircleColor(start: HexColor(primaryColor), end: Colors.red),
          bubblesColor: BubblesColor(
              dotPrimaryColor: Colors.red,
              dotSecondaryColor: HexColor(primaryColor),
              dotThirdColor: Colors.yellow,
              dotLastColor: Colors.green),
          countPostion: CountPostion.bottom,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          likeCountPadding: EdgeInsets.only(top: 10, left: 40),
          onTap: (isLiked) async {
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
              ),
            ),
          ),
          padding: EdgeInsets.only(right: 5),
          likeCount: int.tryParse(Numeral(likes).format()),
          likeBuilder: (bool isLiked) {
            return isLiked
                ? Icon(
                    Icons.favorite,
                    color: HexColor(primaryColor),
                    size: 35,
                  )
                : SvgPicture.asset(
                    "assets/icon/tick_heart.svg",
                    color: HexColor(backgroundColor),
                    height: 45,
                    width: 45,
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
