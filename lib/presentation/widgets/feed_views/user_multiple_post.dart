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
import '../../constants/string.dart';
import '../../screens/home/Feed/feed_video_cache.dart';
import '../../screens/home/Feed/feed_video_holder.dart';
import '../../uiproviders/screen/tab_provider.dart';
import '../debug_emitter.dart';
import '../loader.dart';

class UserMultiplePost extends StatelessWidget {
  final List<String>? media;
  final BoxConstraints? constraints;
  final FeedPost? data;
  final bool isHome;
  final List<String>? thumbLinks;
  final String page;

  UserMultiplePost(
      {super.key,
      this.media,
      this.constraints,
      required this.data,
      required this.isHome,
      required this.thumbLinks, required this.page});

  @override
  Widget build(BuildContext context) {
    TabProvider stream = context.watch<TabProvider>();
    return Stack(
      children: [
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
            );
          },
        ),
        Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...media!.map((e) => Container(
                      color: e.replaceAll('\\', '/') ==
                              stream.image.replaceAll('\\', '/')
                          ? HexColor(primaryColor)
                          : HexColor("#6A6A6A"),
                      width: 25,
                      height: 3,
                    ))
              ],
            ),
          ],
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

  UserMultipleView(
      {super.key,
      this.media,
      this.constraints,
      required this.data,
      required this.index,
      required this.isHome,
      required this.thumbLink, required this.page});

  @override
  State<UserMultipleView> createState() => _UserMultipleViewState();
}

class _UserMultipleViewState extends State<UserMultipleView> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (!widget.media!.contains("https")) {
      _controller = VideoPlayerController.network(
          "$muxStreamBaseUrl/${widget.media}.$videoExtension"

          //   videoPlayerOptions: VideoPlayerOptions()
          );

      _controller!.initialize().whenComplete(() {
        _controller!.play();
        //_controller!.play();
        setState(() {});
      }).then((value) => {
            _controller!.addListener(() {
              if (_controller!.value.position.inSeconds > 7 &&
                  _controller!.value.position.inSeconds < 10) {
                ViewController.handleView(widget.data.id!);
                //log("Watched more than 10 seconds");
              }
            })
          });

      // Use the controller to loop the video.
      setState(() {});
      _controller!.setLooping(true);
    //  setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) {
      //  setState(() {});

        TabProvider action = Provider.of<TabProvider>(context, listen: false);

          action.addHoldControl(_controller!);

        action.tap(true);
      });
    } else {
      Future.delayed(const Duration(seconds: 2))
          .whenComplete(() => ViewController.handleView(widget.data.id!));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      TabProvider action = Provider.of<TabProvider>(context, listen: false);
      action.changeMultipleImage(widget.media!);
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
            controller: _controller!,
            shouldPlay: true,
            isHome: widget.isHome,
            thumbLink: widget.thumbLink,
            page: widget.page,
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      widget.media!.replaceAll('\\', '/'),
                    ),
                    fit: BoxFit.fill,
                  )),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.0)),
                    ),
                  )),
              CachedNetworkImage(
                imageUrl: widget.media!.replaceAll('\\', '/'),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: Loader(
                  color: HexColor(primaryColor),
                )),
                errorWidget: (context, url, error) => Icon(
                  Icons.error,
                  color: HexColor(primaryColor),
                ),
              ),
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
