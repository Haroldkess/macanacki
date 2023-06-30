import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/model/feed_post_model.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/constants/params.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/operations.dart';
import 'package:makanaki/presentation/uiproviders/screen/comment_provider.dart';
import 'package:makanaki/presentation/widgets/loader.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/controllers/action_controller.dart';
import 'package:makanaki/services/controllers/create_post_controller.dart';
import 'package:makanaki/services/middleware/action_ware.dart';
import 'package:makanaki/services/middleware/create_post_ware.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';

import 'hexagon_avatar.dart';

commentModal(BuildContext context, int id, String page) async {
  var height = MediaQuery.of(context).size.height;
  var width = MediaQuery.of(context).size.width;
  var size = MediaQuery.of(context).size;
  var padding = 8.0;
  var w = (size.width - 4 * 1) / 10;
  TextEditingController comment = TextEditingController();
  Operations.stopCommentLoad(context);
  ScrollController control = ScrollController();
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        StoreComment stream = context.watch<StoreComment>();
        ActionWare action = context.watch<ActionWare>();

        return Scaffold(
          //    resizeToAvoidBottomInset: true,
          body: Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 8.0,
              right: 8.0,
            ),
            child: Container(
              // height: height,
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      commentHeader(context),
                      Expanded(
                        //height: height / 2,
                        child: stream.comments
                                .where((element) => element.postId == id)
                                .toList()
                                .isEmpty
                            ? Center(
                                child: AppText(
                                  text: "Be the first to comment!",
                                  size: 16,
                                  fontWeight: FontWeight.w400,
                                  color: HexColor(primaryColor),
                                ),
                              )
                            : Column(
                                children: [
                                  Expanded(
                                      child: ListView.builder(
                                          controller: control,
                                          itemCount: stream.comments
                                              .where((element) =>
                                                  element.postId == id)
                                              .toList()
                                              .length,
                                          reverse: stream.comments
                                                      .where((element) =>
                                                          element.postId == id)
                                                      .toList()
                                                      .length >
                                                  10
                                              ? true
                                              : false,
                                          itemBuilder: (context, index) {
                                            return CommentTile(
                                              e: stream.comments
                                                  .where((element) =>
                                                      element.postId == id)
                                                  .toList()[index],
                                              id: id,
                                            );
                                          })),
                                  // Column(
                                  //   // mainAxisSize: MainAxisSize.min,
                                  //   children: stream.comments
                                  //       .map((e) => CommentTile(
                                  //             e: e,
                                  //             id: id,
                                  //           ))
                                  //       .toList(),
                                  // ),
                                  const SizedBox(
                                    height: 77,
                                  )
                                ],
                              ),
                      ),
                    ],
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: CommentForm(
                        comment: comment,
                        id: id,
                        page: page,
                        control: control,
                      )),
                  // SizedBox(
                  //   height: MediaQuery.of(context).viewInsets.bottom,
                  // ),
                ],
              ),
            ),
          ),
        );
      });
}

commentHeader(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      BackButton(
        color: HexColor(darkColor),
      ),
      AppText(
        text: "Comments",
        fontWeight: FontWeight.w700,
        size: 20,
        align: TextAlign.center,
      ),
      const BackButton(
        color: Colors.transparent,
        onPressed: null,
      ),
    ],
  );
}

class CommentForm extends StatefulWidget {
  TextEditingController comment;
  final int id;
  String page;
  ScrollController control;
  CommentForm(
      {super.key,
      required this.comment,
      required this.id,
      required this.page,
      required this.control});

  @override
  State<CommentForm> createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  FocusNode _focusNode = FocusNode();
  bool typing = false;
  bool done = false;

  @override
  void initState() {
    super.initState();

    // _focusNode.addListener(() {
    //   if (_focusNode.hasFocus) {
    //     _controller!.forward();
    //   } else {
    //     _controller!.reverse();
    //   }
    // });
  }

  @override
  void dispose() {
    //_controller!.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CreatePostWare ware = Provider.of<CreatePostWare>(context, listen: false);
    CreatePostWare stream = context.watch<CreatePostWare>();
    return InkWell(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Card(
        color: Colors.transparent,
        elevation: 10,
        shadowColor: HexColor("#D8D1F4"),
        child: InkWell(
          // onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            height: 58,
            width: 379,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: HexColor(backgroundColor),
                shape: BoxShape.rectangle,
                border: Border.all(
                    width: 1.0,
                    color: HexColor("#E8E6EA"),
                    style: BorderStyle.solid),
                borderRadius: const BorderRadius.all(Radius.circular(8.0))),
            child: TextFormField(
              controller: widget.comment,
              cursorColor: HexColor(primaryColor),
              focusNode: _focusNode,
              keyboardType: TextInputType.multiline,
              // onTap: () async {
              //   print("hello");
              //   // FocusScope.of(context).requestFocus(FocusNode());
              //   setState(() {
              //     done = false;
              //   });
              // },
              onChanged: (val) {
                if (val.isNotEmpty) {
                  setState(() {
                    typing = true;
                  });
                } else {
                  setState(() {
                    typing = false;
                  });
                }
              },
              decoration: InputDecoration(
                hintText: "Write a comment...",
                hintStyle: GoogleFonts.spartan(
                    color: HexColor("#8B8B8B"), fontSize: 14),
                contentPadding: EdgeInsets.only(left: 10, top: 15),
                // prefixIcon: Padding(
                //   padding: const EdgeInsets.all(15.0),
                //   child: SvgPicture.asset(
                //     "assets/icon/sticker.svg",
                //     height: 5,
                //     width: 5,
                //     color: const Color.fromRGBO(0, 0, 0, 0.4),
                //   ),
                // ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: stream.loadStatus2
                      ? Loader(color: HexColor(primaryColor))
                      : InkWell(
                          onTap: () async {
                            if (widget.comment.text.isEmpty) {
                              log("empty comment");
                              return;
                            } else {
                              log(widget.id.toString());
                              await _submitComment(
                                  widget.id, context, widget.page);
                              _focusNode.unfocus();
                              // widget.control.animateTo(
                              //   widget.control.position.maxScrollExtent,
                              //   curve: Curves.easeOut,
                              //   duration: const Duration(milliseconds: 300),
                              // );
                            }
                          },
                          child: SvgPicture.asset(
                            "assets/icon/Send.svg",
                            height: 7,
                            width: 7,
                            color:
                                typing ? HexColor(primaryColor) : Colors.grey,
                          ),
                        ),
                ),

                border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(2.0),
                    borderSide: const BorderSide(color: Colors.transparent)),
                enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(2.0),
                    borderSide: const BorderSide(color: Colors.transparent)),
                focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(2.0),
                    borderSide: const BorderSide(color: Colors.transparent)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _submitComment(int id, BuildContext context, String page) async {
    // Comment data =Comment(
    //   id:
    // );
    await CreatePostController.shareCommentController(
        context, widget.comment, id, page);
  }
}

class CommentTile extends StatelessWidget {
  dynamic e;
  int id;
  CommentTile({super.key, required this.e, required this.id});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    ActionWare action = context.watch<ActionWare>();
    var w = 30.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      height: 43,
                      width: 47,
                      // color: Colors.amber,
                      child: Stack(
                        children: [
                            HexagonWidget.pointy(
                                  width: w - 3,
                                  elevation: 2.0,
                                  color: Colors.white,
                                  cornerRadius: 2.0,
                                  child: AspectRatio(
                                    aspectRatio: HexagonType.POINTY.ratio,
                                    // child: Image.asset(
                                    //   'assets/tram.jpg',
                                    //   fit: BoxFit.fitWidth,
                                    // ),
                                  ),
                                ),
                          // HexagonWidget.pointy(
                          //   width: w,
                          //   elevation: 2.0,
                          //   color: Colors.white,
                          //   cornerRadius: 20.0,
                          //   child: AspectRatio(
                          //     aspectRatio: HexagonType.POINTY.ratio,
                          //     // child: Image.asset(
                          //     //   'assets/tram.jpg',
                          //     //   fit: BoxFit.fitWidth,
                          //     // ),
                          //   ),
                          // ),
                          HexagonAvatar(
                              url:
                                  e.profilePhoto == null ? "" : e.profilePhoto!,
                              w: w),
                        ],
                      )),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Row(
                        children: [
                          Container(
                            constraints: BoxConstraints(maxWidth: 100),
                            child: AppText(
                              text: e.username!,
                              fontWeight: FontWeight.w700,
                              size: 12,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          AppText(
                            text: Operations.times(e.createdAt),
                            fontWeight: FontWeight.w400,
                            size: 10,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 200),
                        // color: Colors.amber,
                        child: AppText(
                          text: e.body!,
                          fontWeight: FontWeight.w500,
                          size: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 10),
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          child: InkWell(
                            onTap: () async {
                              ActionWare provide = Provider.of<ActionWare>(
                                  context,
                                  listen: false);
                              provide.addCommentId(e.id!);
                              await ActionController
                                  .likeOrDislikeCommentController(
                                      context, id, e.id!);
                            },
                            child: action.commentId.contains(e.id)
                                ? Icon(
                                    Icons.favorite,
                                    color: HexColor(primaryColor),
                                    size: 20,
                                  )
                                : SvgPicture.asset(
                                    'assets/icon/heart.svg',
                                    height: 15,
                                    width: 15,
                                    color: HexColor("#8B8B8B"),
                                  ),
                          ),
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    AppText(
                      text: action.commentId.contains(e.id)
                          ? Numeral(e.noOfLikes! + 1).format()
                          : Numeral(e.noOfLikes!).format(),
                      size: 11,
                      fontWeight: FontWeight.w400,
                      color: HexColor("#C0C0C0"),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  // ListTile(
  //     leading: Padding(
  //       padding: const EdgeInsets.only(bottom: 0.0),
  //       child: Container(
  //           height: 43,
  //           width: 47,
  //           // color: Colors.amber,
  //           child: Stack(
  //             children: [
  //               HexagonWidget.pointy(
  //                 width: w,
  //                 elevation: 2.0,
  //                 color: Colors.white,
  //                 cornerRadius: 20.0,
  //                 child: AspectRatio(
  //                   aspectRatio: HexagonType.POINTY.ratio,
  //                   // child: Image.asset(
  //                   //   'assets/tram.jpg',
  //                   //   fit: BoxFit.fitWidth,
  //                   // ),
  //                 ),
  //               ),
  //               HexagonAvatar(
  //                   url: e.profilePhoto == null ? "" : e.profilePhoto!, w: w),
  //             ],
  //           )),
  //     ),
  //     title: Padding(
  //       padding: const EdgeInsets.only(top: 0.0),
  //       child: Row(
  //         children: [
  //           Container(
  //             constraints: BoxConstraints(maxWidth: 100),
  //             child: AppText(
  //               text: e.username!,
  //               fontWeight: FontWeight.w700,
  //               size: 12,
  //             ),
  //           ),
  //           const SizedBox(
  //             width: 5,
  //           ),
  //           AppText(
  //             text: Operations.times(e.createdAt),
  //             fontWeight: FontWeight.w400,
  //             size: 10,
  //           ),
  //         ],
  //       ),
  //     ),
  //     subtitle: Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 8.0),
  //       child: AppText(
  //         text: e.body!,
  //         fontWeight: FontWeight.w600,
  //         size: 10,
  //       ),
  //     ),
  //     trailing: Padding(
  //       padding: const EdgeInsets.only(bottom: 5.0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: [
  //           AnimatedContainer(
  //               duration: const Duration(milliseconds: 500),
  //               child: Container(
  //                 child: InkWell(
  //                   onTap: () async {
  //                     ActionWare provide =
  //                         Provider.of<ActionWare>(context, listen: false);
  //                     provide.addCommentId(e.id!);
  //                     await ActionController.likeOrDislikeCommentController(
  //                         context, id, e.id!);
  //                   },
  //                   child: action.commentId.contains(e.id)
  //                       ? Icon(
  //                           Icons.favorite,
  //                           color: HexColor(primaryColor),
  //                           size: 20,
  //                         )
  //                       : SvgPicture.asset(
  //                           'assets/icon/heart.svg',
  //                           height: 15,
  //                           width: 15,
  //                           color: HexColor("#8B8B8B"),
  //                         ),
  //                 ),
  //               )),
  //           const SizedBox(
  //             height: 5,
  //           ),
  //           AppText(
  //             text: action.commentId.contains(e.id)
  //                 ? Numeral(e.noOfLikes! + 1).format()
  //                 : Numeral(e.noOfLikes!).format(),
  //             size: 11,
  //             fontWeight: FontWeight.w400,
  //             color: HexColor("#C0C0C0"),
  //           )
  //         ],
  //       ),
  //     ),
  //   );

}
