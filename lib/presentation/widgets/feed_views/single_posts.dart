import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:apivideo_player/apivideo_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/widgets/feed_views/image_holder.dart';
import 'package:macanacki/services/middleware/video/video_ware.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/animation_builder/play_animation_builder.dart';
import 'package:video_player/video_player.dart';

import '../../../model/feed_post_model.dart';
import '../../../services/middleware/feed_post_ware.dart';
import '../../../services/middleware/post_security.dart';
import '../../../services/middleware/user_profile_ware.dart';
import '../../allNavigation.dart';
import '../../constants/colors.dart';
import '../../constants/string.dart';
import '../../screens/home/Feed/feed_audio_holder.dart';
import '../../screens/home/Feed/feed_video_cache.dart';
import '../../screens/home/Feed/feed_video_holder.dart';
import '../../screens/home/Feed/user_feed_audio_holder.dart';
import '../loader.dart';

class SinglePost extends StatelessWidget {
  final String media;
  // final VideoPlayerController? controller;
  final bool shouldPlay;
  final BoxConstraints? constraints;
  final bool isHome;
  final String? thumbLink;
  bool isInView;
  final postId;
  final FeedPost data;
  final String? vod;
  List<dynamic> allPost;
  SinglePost(
      {super.key,
      required this.media,
      //   required this.controller,
      required this.shouldPlay,
      required this.constraints,
      required this.isHome,
      required this.thumbLink,
      required this.isInView,
      required this.allPost,
      required this.postId,
      required this.vod,
      required this.data});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    FeedPostWare stream = context.watch<FeedPostWare>();
    const textStyle = TextStyle(color: Colors.white);
    final buttonStyle = TextButton.styleFrom(
        iconColor: Colors.white,
        foregroundColor: Colors.white,
        side: BorderSide.none,
        textStyle: textStyle);

    final controlsBarStyle = ControlsBarStyle(
      mainControlButtonStyle: buttonStyle,
    );
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (!media.contains("https")) {
    //     PostSecurity.instance.toggleSecure(false);
    //   } else {
    //     PostSecurity.instance.toggleSecure(true);
    //   }
    // });
    return media.contains(".mp4") ||
            media.contains(".mp3") ||
            !media.contains("https")
        ? Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(color: Colors.black),
              ),
              GestureDetector(
                onTap: () async {
                  if (media.contains(".mp3")) {
                    VideoWareHome.instance
                        .addAudioToList(data)
                        .whenComplete(() {
                      // VideoWareHome.instance.initSomeVideo(
                      //     "$muxStreamBaseUrl/$media.$videoExtension",
                      //     data.id!,
                      //     0);
                      PageRouting.pushToPage(
                        context,
                        FeedAudioHolder(
                          file: "$muxStreamBaseUrl/$media.$videoExtension",
                          // controller: controller!,
                          shouldPlay: true,
                          isHome: isHome,
                          vod: vod ?? "",
                          thumbLink: thumbLink ?? "",
                          page: "feed",
                          isInView: isInView,
                          extended: false,
                          postId: postId,
                          data: data,
                        ),
                      );
                    });
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      VideoWareHome.instance.viewToggle(0);
                      // VideoWareHome.instance.loadVideo(true);
                    });

                    VideoWareHome.instance
                        .addVideoToList(data)
                        .whenComplete(() {
                      // VideoWareHome.instance.initSomeVideo(
                      //     "$muxStreamBaseUrl/$media.$videoExtension",
                      //     data.id!,
                      //     0);
                      PageRouting.pushToPage(
                        context,
                        FeedVideoHolder(
                          file: "$muxStreamBaseUrl/$media.$videoExtension",
                          // controller: controller!,
                          shouldPlay: true,
                          isHome: isHome,
                          vod: vod!,
                          thumbLink: thumbLink ?? "",
                          page: "feed",
                          isInView: isInView,
                          extended: false,

                          postId: postId,
                          data: data,
                        ),
                      );
                    });
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: data.btnLink != null && data.button != null
                          ? 80
                          : data.description!.isEmpty
                              ? 10
                              : 40),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                          height: 350,
                          width: double.infinity,
                          child: Container(
                            // height: 350,
                            height: data.btnLink != null && data.button != null
                                ? 380
                                : data.description!.isEmpty
                                    ? 430
                                    : 410,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              //   borderRadius: BorderRadius.circular(15),
                            ),
                            child: CachedNetworkImage(
                                imageUrl: data.thumbnails!.isEmpty
                                    ? ""
                                    : data.thumbnails!.first ?? "",
                                fit: BoxFit.fitWidth,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      width: width,
                                      height: height,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.fitWidth,
                                          )),
                                    ),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                            child: Loader(
                                          color: textWhite,
                                        )),
                                errorWidget: (context, url, error) {
                                  return CachedNetworkImage(
                                      imageUrl: data.thumbnails!.isEmpty
                                          ? ""
                                          : data.thumbnails!.first ?? "",
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                            width: width,
                                            height: height,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.fitWidth,
                                                )),
                                          ),
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          Center(
                                              child: Loader(color: textWhite)),
                                      errorWidget: (context, url, error) {
                                        return SizedBox();
                                      });
                                }),
                          )),
                      PlayAnimationBuilder<double>(
                          tween: Tween(begin: 10.0, end: 50.0), // set tween
                          duration: const Duration(
                              milliseconds: 1000), // set duration
                          builder: (context, value, _) {
                            return Container(
                              height: value,
                              width: value,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  border: Border.all(
                                      width: 4.0, color: Colors.white)),
                              child: Center(
                                child: IconButton(
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    // size: 35,
                                  ),
                                  style:
                                      controlsBarStyle.mainControlButtonStyle,
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                ),
              ),
            ],
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              // Container(
              //   width: width,
              //   height: height,
              //   decoration: BoxDecoration(color: Colors.black),
              // ),

              Padding(
                padding: EdgeInsets.only(
                    top: 0,
                    bottom: data.btnLink != null && data.button != null
                        ? 80
                        : data.description!.isEmpty
                            ? 10
                            : 40),
                child: GestureDetector(
                  onTap: () {
                    PageRouting.pushToPage(
                        context,
                        EnlargeImageHolder(
                            images: [media],
                            page: "feed",
                            data: data,
                            index: 0));
                  },
                  child: Container(
                    height: data.btnLink != null && data.button != null
                        ? 380
                        : data.description!.isEmpty
                            ? 430
                            : 410,
                    //   height: 430,
                    // height: data.description!.isEmpty ? Get.height : 400,
                    width: double.infinity,
                    //   color: Colors.amber,

                    child: CachedNetworkImage(
                        imageUrl: media,
                        fit: BoxFit.fitWidth,
                        imageBuilder: (context, imageProvider) => Container(
                              width: width,
                              height: height,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fitWidth,
                                  )),
                            ),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                                    child: Loader(
                                  color: textWhite,
                                )),
                        errorWidget: (context, url, error) {
                          return CachedNetworkImage(
                              imageUrl: media,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    width: width,
                                    height: height,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fitWidth,
                                        )),
                                  ),
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      Center(child: Loader(color: textWhite)),
                              errorWidget: (context, url, error) {
                                return SizedBox();
                              });
                        }),
                  ),
                ),
              ),
              // Image(
              //   //  fit: BoxFit.fitWidth,
              //   width: constraints!.maxWidth,
              //   image: media.contains("/data/user/0/")
              //       ? FileImage(File(media))
              //       : CachedNetworkImageProvider(
              //           media.replaceAll('\\', '/'),
              //         ) as ImageProvider,
              // ),
            ],
          );
  }
}

class UserSinglePost extends StatelessWidget {
  final String media;
  //final VideoPlayerController? controller;
  // VlcPlayerController? vlcController;

  final bool shouldPlay;
  final BoxConstraints? constraints;
  final bool isHome;
  final String? thumbLink;
  final String page;
  bool? isInView;
  int postId;
  final FeedPost data;
  String? vod;
  bool showComment;
  List<dynamic> allPost;
  UserSinglePost(
      {super.key,
      required this.media,
      required this.vod,
      // required this.controller,
      required this.shouldPlay,
      required this.constraints,
      required this.isHome,
      required this.thumbLink,
      required this.allPost,
      required this.page,
      required this.isInView,
      required this.postId,
      required this.data,
      required this.showComment});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    FeedPostWare stream = context.watch<FeedPostWare>();
    UserProfileWare user = context.watch<UserProfileWare>();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (data.user!.username! == user.userProfileModel.username) {
    //     PostSecurity.instance.toggleSecure(false);
    //   } else {
    //     if (!media.contains("https")) {
    //       PostSecurity.instance.toggleSecure(false);
    //     } else {
    //       PostSecurity.instance.toggleSecure(true);
    //     }
    //   }
    // });

    const textStyle = TextStyle(color: Colors.white);
    final buttonStyle = TextButton.styleFrom(
        iconColor: Colors.white,
        foregroundColor: Colors.white,
        side: BorderSide.none,
        textStyle: textStyle);

    final controlsBarStyle = ControlsBarStyle(
      mainControlButtonStyle: buttonStyle,
    );
    return media.contains(".mp4") ||
            media.contains(".mp3") ||
            !media.contains("https")
        ? Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(color: Colors.black),
              ),
              StreamBuilder<Object>(
                  stream: null,
                  builder: (context, snapshot) {
                    // List<String> data = stream.thumbs.where((val) {
                    //   return val.contains(thumbLink);
                    // }).toList();
                    // if (data.isEmpty) {
                    //   //   emitter("nothing found ${widget.controller.value.isPlaying}");
                    // } else {
                    //   var val = data.first.split(thumbLink);

                    //   // emitter(val.first + "  Second" + val.last);
                    // }
                    return GestureDetector(
                      onTap: () async {
                        if (media.contains(".mp3")) {
                          VideoWare.instance
                              .addAudioToList(data)
                              .whenComplete(() {
                            // VideoWareHome.instance.initSomeVideo(
                            //     "$muxStreamBaseUrl/$media.$videoExtension",
                            //     data.id!,
                            //     0);
                            PageRouting.pushToPage(
                              context,
                              FeedAudioHolderUser(
                                file:
                                    "$muxStreamBaseUrl/$media.$videoExtension",
                                // controller: controller!,
                                shouldPlay: true,
                                isHome: isHome,
                                vod: vod ?? "",
                                thumbLink: thumbLink ?? "",
                                page: page,
                                isInView: isInView,
                                postId: postId,
                                extended: true,
                                data: data,
                                showComment: showComment,
                              ),
                            );
                          });
                        } else {
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            VideoWare.instance.viewToggle(0);
                          });
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            VideoWare.instance.loadVideo(true);
                          });
                          log(allPost.length.toString());

                          await VideoWare.instance
                              .getVideoPostFromApi(allPost)
                              .whenComplete(() {
                            VideoWare.instance
                                .addVideoToList(data)
                                .whenComplete(() {
                              PageRouting.pushToPage(
                                context,
                                FeedVideoHolderPrivate(
                                  file:
                                      "$muxStreamBaseUrl/$media.$videoExtension",
                                  // controller: controller!,
                                  shouldPlay: true,
                                  isHome: isHome,
                                  thumbLink: thumbLink ?? "",
                                  page: page,
                                  extended: true,
                                  isInView: isInView,
                                  postId: postId,
                                  data: data,
                                  showComment: showComment,
                                ),
                              );
                            });
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                                height: 330,
                                width: double.infinity,
                                child: thumbLink == null
                                    ? Container(
                                        height: 350,
                                        width: double.infinity,
                                        color: Colors.black,
                                      )
                                    : Container(
                                        height: 350,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  thumbLink.toString()),
                                              fit: BoxFit.cover,
                                            )),
                                      )),

                            PlayAnimationBuilder<double>(
                                tween:
                                    Tween(begin: 10.0, end: 50.0), // set tween
                                duration: const Duration(
                                    milliseconds: 1000), // set duration
                                builder: (context, value, _) {
                                  return Container(
                                    height: value,
                                    width: value,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(13),
                                        border: Border.all(
                                            width: 4.0, color: Colors.white)),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: null,
                                        icon: Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          // size: 35,
                                        ),
                                        style: controlsBarStyle
                                            .mainControlButtonStyle,
                                      ),
                                    ),
                                  );
                                })

                            // Container(
                            //   height: 50,
                            //   width: 50,
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(13),
                            //       border: Border.all(
                            //           width: 4.0, color: Colors.white)),
                            //   child: Center(
                            //     child: IconButton(
                            //       onPressed: null,
                            //       icon: Icon(
                            //         Icons.play_arrow,
                            //         color: Colors.white,
                            //         // size: 35,
                            //       ),
                            //       style:
                            //           controlsBarStyle.mainControlButtonStyle,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(color: Colors.black),
              ),
              // Container(
              //     width: width,
              //     height: height,
              //     decoration: BoxDecoration(
              //         image: DecorationImage(
              //       image: CachedNetworkImageProvider(
              //         media,
              //       ),
              //       fit: BoxFit.fill,
              //     )),
              //     child: BackdropFilter(
              //       filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              //       child: Container(
              //         decoration:
              //             BoxDecoration(color: Colors.white.withOpacity(0.0)),
              //       ),
              //     )),
              Padding(
                padding: EdgeInsets.only(
                    top: 0,
                    bottom: data.btnLink != null && data.button != null
                        ? 80
                        : data.description!.isEmpty
                            ? 10
                            : 40),
                child: GestureDetector(
                  onTap: () {
                    PageRouting.pushToPage(
                        context,
                        EnlargeImageHolder(
                            images: [media],
                            page: "public",
                            data: data,
                            index: 0));
                  },
                  child: Container(
                    // height: 330,
                    height: data.btnLink != null && data.button != null
                        ? 380
                        : data.description!.isEmpty
                            ? 430
                            : 410,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: media,
                      fit: BoxFit.fitWidth,
                      imageBuilder: (context, imageProvider) => Container(
                        width: width,
                        height: height,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fitWidth,
                            )),
                      ),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                              child: Loader(
                        color: textPrimary,
                      )),
                      errorWidget: (context, url, error) => CachedNetworkImage(
                          imageUrl: media,
                          fit: BoxFit.fitWidth,
                          imageBuilder: (context, imageProvider) => Container(
                                width: width,
                                height: height,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fitWidth,
                                    )),
                              ),
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                                      child: Loader(
                                    color: textPrimary,
                                  )),
                          errorWidget: (context, url, error) {
                            return SizedBox();
                          }),
                    ),
                  ),
                ),
              ),
              // Image(
              //   //  fit: BoxFit.fitWidth,
              //   width: constraints!.maxWidth,
              //   image: media.contains("/data/user/0/")
              //       ? FileImage(File(media))
              //       : CachedNetworkImageProvider(
              //           media.replaceAll('\\', '/'),
              //         ) as ImageProvider,
              // ),
            ],
          );
  }
}
