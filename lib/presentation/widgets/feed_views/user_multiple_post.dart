import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../../model/feed_post_model.dart';
import '../../../services/controllers/view_controller.dart';
import '../../../services/middleware/post_security.dart';
import '../../../services/middleware/user_profile_ware.dart';
import '../../allNavigation.dart';
import '../../constants/string.dart';
import '../../screens/home/Feed/feed_video_cache.dart';
import '../../screens/home/Feed/feed_video_holder.dart';
import '../../uiproviders/screen/tab_provider.dart';
import '../debug_emitter.dart';
import '../loader.dart';
import 'image_holder.dart';

class UserMultiplePost extends StatelessWidget {
  final List<String>? media;
  final BoxConstraints? constraints;
  final FeedPost? data;
  final bool isHome;
  final List<String>? thumbLinks;
  final String page;
  bool? isInView;

  UserMultiplePost(
      {super.key,
      this.media,
      this.constraints,
      required this.data,
      required this.isHome,
      required this.thumbLinks,
      required this.page,
      required this.isInView});

  @override
  Widget build(BuildContext context) {
    TabProvider stream = context.watch<TabProvider>();
    UserProfileWare user = context.watch<UserProfileWare>();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (data!.user!.username! == user.userProfileModel.username) {
    //     PostSecurity.instance.toggleSecure(false);
    //   } else {
    //     PostSecurity.instance.toggleSecure(true);
    //   }
    // });
    return Stack(
      children: [
        Row(
          children: media == null
              ? []
              : List.generate(
                  media == null ? 0 : media!.length,
                  (index) => Container(
                    height: 1,
                    width: 1,
                    child: CachedNetworkImage(imageUrl: media![index] ?? ""),
                  ),
                ),
        ),
        PageView.builder(
          itemCount: media!.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            // TabProvider action =
            //     Provider.of<TabProvider>(context, listen: false);
            // action.changeMultipleIndex(index);
            return UserMultipleView(
              data: data!,
              media: media![index],
              constraints: constraints,
              index: index,
              isHome: isHome,
              thumbLink: thumbLinks![index],
              page: page,
              images: media!,
              isInView: isInView,
            );
          },
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...media!.map((e) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: CircleAvatar(
                          backgroundColor: e.replaceAll('\\', '/') ==
                                  stream.image.replaceAll('\\', '/')
                              ? HexColor(primaryColor)
                              : HexColor("#6A6A6A"),
                          radius: 3,
                          //   width: 25,
                          //   height: 3,
                        ),
                      ))
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class UserMultipleView extends StatefulWidget {
  final String? media;
  final BoxConstraints? constraints;
  final FeedPost data;
  final int index;
  final bool isHome;
  final String thumbLink;
  final String page;
  bool? isInView;
  final List<String> images;

  UserMultipleView(
      {super.key,
      this.media,
      this.constraints,
      required this.data,
      required this.index,
      required this.isHome,
      required this.thumbLink,
      required this.page,
      required this.isInView,
      required this.images});

  @override
  State<UserMultipleView> createState() => _UserMultipleViewState();
}

class _UserMultipleViewState extends State<UserMultipleView> {
  VideoPlayerController? _controller;
  FeedPost? thisData;
  @override
  void initState() {
    super.initState();
    if (!widget.media!.contains("https")) {
      // _controller = VideoPlayerController.network(
      //     "$muxStreamBaseUrl/${widget.media}.$videoExtension"

      //     //   videoPlayerOptions: VideoPlayerOptions()
      //     );
      // thisData = widget.data.copyWith(controller: _controller);

      // thisData!.controller!.initialize().whenComplete(() {
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     TabProvider provide =
      //         Provider.of<TabProvider>(context, listen: false);
      //     if (provide.index == 0) {
      //       //  thisData!.controller!.play();
      //       // provide.tap(false);
      //     } else {
      //       if (provide.index == 4 && provide.isHome) {
      //         emitter("heyyyyy");
      //         //  thisData!.controller!.play();
      //         //   provide.tap(false);
      //       } else {
      //         //   thisData!.controller!.pause();
      //       }
      //     }
      //   });
      //   //_controller!.play();
      //   setState(() {});
      // }).then((value) => {
      //       thisData!.controller!.addListener(() {
      //         if (thisData!.controller!.value.position.inSeconds > 7 &&
      //             thisData!.controller!.value.position.inSeconds < 10) {
      //           ViewController.handleView(widget.data.id!);
      //           //log("Watched more than 10 seconds");
      //         }
      //       })
      //     });

      // // Use the controller to loop the video.

      // thisData!.controller!.setLooping(true);
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   TabProvider action = Provider.of<TabProvider>(context, listen: false);

      //   action.addHoldControl(thisData!.controller!);
      //   action.tap(true);
      // });
    } else {
      Future.delayed(const Duration(seconds: 2))
          .whenComplete(() => ViewController.handleView(widget.data.id!));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        TabProvider action = Provider.of<TabProvider>(context, listen: false);
        action.changeMultipleImage(widget.media!);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    //  _controller!.dispose();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   TabProvider action = Provider.of<TabProvider>(context, listen: false);

    //   action.disControl();
    // });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return !widget.media!.contains("https")
        ? FeedVideoHolderPrivate(
            file: "$muxStreamBaseUrl/${widget.media}.$videoExtension",
            //  controller: thisData == null ? null : thisData!.controller!,
            shouldPlay: true,
            isHome: widget.isHome,
            thumbLink: widget.thumbLink,
            page: widget.page,
            isInView: widget.isInView,
            postId: 0,
            data: widget.data,
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
              //   width: width,
              //   height: height,
              //   decoration: BoxDecoration(

              //         image: DecorationImage(
              //       image: CachedNetworkImageProvider(
              //         widget.media!.replaceAll('\\', '/'),
              //       ),
              //       fit: BoxFit.fill,

              //     )
              //   ),
              //   child: BackdropFilter(
              //     filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              //     child: Container(
              //       decoration:
              //           BoxDecoration(color: Colors.white.withOpacity(0.0)),
              //     ),
              //   )
              // ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: GestureDetector(
                  onTap: () {
                    PageRouting.pushToPage(
                        context,
                        EnlargeImageHolder(
                            images: widget.images,
                            page: "feed",
                            data: widget.data,
                            index: widget.index));
                  },
                  child: Container(
                    height: 330,
                    //  color: Colors.amber,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: widget.media!.replaceAll('\\', '/'),
                      fit: BoxFit.cover,
                      imageBuilder: (context, imageProvider) => Container(
                        width: width,
                        height: height,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        )),
                      ),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                              child: Loader(
                        color: HexColor(primaryColor),
                      )),
                      errorWidget: (context, url, error) => CachedNetworkImage(
                          imageUrl: widget.media!.replaceAll('\\', '/'),
                          fit: BoxFit.cover,
                          imageBuilder: (context, imageProvider) => Container(
                                width: width,
                                height: height,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
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
              // CachedNetworkImage(
              //   imageUrl: widget.media!.replaceAll('\\', '/'),
              //   progressIndicatorBuilder: (context, url, downloadProgress) =>
              //       Center(
              //           child: Loader(
              //     color: HexColor(primaryColor),
              //   )),
              //   errorWidget: (context, url, error) => Icon(
              //     Icons.error,
              //     color: HexColor(primaryColor),
              //   ),
              // ),
              // Image(
              //   //  fit: BoxFit.fitWidth,
              //   width: widget.constraints!.maxWidth,
              //   image: widget.media!.contains("/data/user/0/")
              //       ? FileImage(File(widget.media!))
              //       : NetworkImage(
              //           widget.media!.replaceAll('\\', '/'),
              //         ) as ImageProvider,
              // ),
            ],
          );
  }
}
