import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/widgets/feed_views/image_holder.dart';
import 'package:macanacki/services/middleware/video/video_ware.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../model/feed_post_model.dart';
import '../../../services/middleware/feed_post_ware.dart';
import '../../allNavigation.dart';
import '../../constants/colors.dart';
import '../../constants/string.dart';
import '../../screens/home/Feed/better_video_holder.dart';
import '../../screens/home/Feed/feed_video_cache.dart';
import '../../screens/home/Feed/feed_video_holder.dart';
import '../loader.dart';

// List<String> data = stream.thumbs.where((val) {
//               return val.contains(thumbLink);
//             }).toList();
//             if (data.isEmpty) {
//               //   emitter("nothing found ${widget.controller.value.isPlaying}");
//             } else {
//               var val = data.first.split(thumbLink);

//               // emitter(val.first + "  Second" + val.last);
//             }

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
  SinglePost(
      {super.key,
      required this.media,
      //   required this.controller,
      required this.shouldPlay,
      required this.constraints,
      required this.isHome,
      required this.thumbLink,
      required this.isInView,
      required this.postId,
      required this.data});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    FeedPostWare stream = context.watch<FeedPostWare>();
    return !media.contains("https")
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
                  // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  VideoWareHome.instance.loadVideo(true);
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    VideoWareHome.instance.viewToggle(0);
                    VideoWareHome.instance.loadVideo(true);
                  });
                  //    });
                  // WidgetsBinding.instance
                  //     .addPostFrameCallback((timeStamp) async {
                  VideoWareHome.instance.addVideoToList(data).whenComplete(() {
                    VideoWareHome.instance.initSomeVideo(
                        "$muxStreamBaseUrl/$media.$videoExtension",
                        data.id!,
                        0);
                    PageRouting.pushToPage(
                      context,
                      FeedVideoHolder(
                        file: "$muxStreamBaseUrl/$media.$videoExtension",
                        // controller: controller!,
                        shouldPlay: true,
                        isHome: isHome,
                        thumbLink: thumbLink ?? "",
                        page: "feed",
                        isInView: isInView,
                        postId: postId,
                        data: data,
                      ),
                    );
                  });

                  // });
                  // if (data.promoted == "yes") {
                  //   await VideoWareHome.instance
                  //       .disposeVideo(data.id!,
                  //           "$muxStreamBaseUrl/$media.$videoExtension")
                  //       .whenComplete(() async {
                  //     await VideoWareHome.instance
                  //         .addVideoToList(data)
                  //         .whenComplete(() => PageRouting.pushToPage(
                  //               context,
                  //               FeedVideoHolder(
                  //                 file:
                  //                     "$muxStreamBaseUrl/$media.$videoExtension",
                  //                 // controller: controller!,
                  //                 shouldPlay: true,
                  //                 isHome: isHome,
                  //                 thumbLink: thumbLink ?? "",
                  //                 page: "feed",
                  //                 isInView: isInView,
                  //                 postId: postId,
                  //                 data: data,
                  //               ),
                  //             ));
                  //   });
                  // } else {

                  //  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                          height: 350,
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
                                            thumbLink!),
                                        fit: BoxFit.cover,
                                      )),
                                )),
                      CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(.7),
                        radius: 30,
                        child: const Icon(
                          Icons.play_arrow_outlined,
                          size: 25,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ),
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
                padding: const EdgeInsets.only(top: 0),
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
                    height: 330,
                    width: double.infinity,
                    //   color: Colors.amber,
                    // decoration: BoxDecoration(
                    //     border: Border.all(width: 2, color: Colors.amber)),
                    child: CachedNetworkImage(
                        imageUrl: media,
                        fit: BoxFit.fitWidth,
                        imageBuilder: (context, imageProvider) => Container(
                              width: width,
                              height: height,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fitWidth,
                              )),
                            ),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                                    child: Loader(
                                  color: HexColor(primaryColor),
                                )),
                        errorWidget: (context, url, error) {
                          return CachedNetworkImage(
                              imageUrl: media,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    width: width,
                                    height: height,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fitWidth,
                                    )),
                                  ),
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                          child: Loader(
                                        color: HexColor(primaryColor),
                                      )),
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
  UserSinglePost({
    super.key,
    required this.media,
    // required this.controller,
    required this.shouldPlay,
    required this.constraints,
    required this.isHome,
    required this.thumbLink,
    required this.page,
    required this.isInView,
    required this.postId,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    FeedPostWare stream = context.watch<FeedPostWare>();
    return !media.contains("https")
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
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          VideoWare.instance.viewToggle(0);
                        });
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          VideoWare.instance.loadVideo(true);
                        });

                        VideoWare.instance
                            .addVideoToList(data)
                            .whenComplete(() {
                          // VideoWareHome.instance.initSomeVideo(
                          //     "$muxStreamBaseUrl/$media.$videoExtension",
                          //     data.id!,
                          //     0);
                          PageRouting.pushToPage(
                            context,
                            FeedVideoHolderPrivate(
                              file: "$muxStreamBaseUrl/$media.$videoExtension",
                              // controller: controller!,
                              shouldPlay: true,
                              isHome: isHome,
                              thumbLink: thumbLink ?? "",
                              page: "public",
                              isInView: isInView,
                              postId: postId,
                              data: data,
                            ),
                          );
                        });
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
                            CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(.7),
                              radius: 30,
                              child: const Icon(
                                Icons.play_arrow_outlined,
                                size: 25,
                                color: Colors.black,
                              ),
                            )
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
                padding: const EdgeInsets.only(top: 0),
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
                    height: 330,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: media,
                      fit: BoxFit.fitWidth,
                      imageBuilder: (context, imageProvider) => Container(
                        width: width,
                        height: height,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fitWidth,
                          //  fit: BoxFit.fill,
                        )),
                      ),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                              child: Loader(
                        color: HexColor(primaryColor),
                      )),
                      errorWidget: (context, url, error) => CachedNetworkImage(
                          imageUrl: media,
                          fit: BoxFit.fitWidth,
                          imageBuilder: (context, imageProvider) => Container(
                                width: width,
                                height: height,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fitWidth,
                                  //  fit: BoxFit.fill,
                                )),
                              ),
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                                      child: Loader(
                                    color: HexColor(primaryColor),
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
