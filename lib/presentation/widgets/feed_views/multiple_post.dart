import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../../model/feed_post_model.dart';
import '../../../services/controllers/view_controller.dart';
import '../../screens/home/Feed/feed_video_holder.dart';
import '../../uiproviders/screen/tab_provider.dart';

class MultiplePost extends StatelessWidget {
  final List<String>? media;
  final BoxConstraints? constraints;
  final FeedPost? data;
  final bool isHome;

  MultiplePost(
      {super.key,
      this.media,
      this.constraints,
      required this.data,
      required this.isHome});

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
            return MultipleView(
              data: data!,
              media: media![index],
              constraints: constraints,
              index: index,
              isHome: isHome,
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

class MultipleView extends StatefulWidget {
  final String? media;
  final BoxConstraints? constraints;
  final FeedPost data;
  final int index;
  final bool isHome;

  MultipleView(
      {super.key,
      this.media,
      this.constraints,
      required this.data,
      required this.index,
      required this.isHome});

  @override
  State<MultipleView> createState() => _MultipleViewState();
}

class _MultipleViewState extends State<MultipleView> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.media!.contains(".mp4")) {
      if (widget.media!.contains("/data/user/0/")) {
        _controller = VideoPlayerController.file(
          File(widget.media!),
        )
          ..setLooping(true)
          ..initialize().then((_) => _controller!.play()).then((value) => {
                _controller!.addListener(() {
                  setState(() {});
                  if (_controller!.value.position.inSeconds > 7 &&
                      _controller!.value.position.inSeconds < 10) {
                    ViewController.handleView(widget.data.id!);
                    //log("Watched more than 10 seconds");
                  }
                })
              });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          TabProvider action = Provider.of<TabProvider>(context, listen: false);

          action.addControl(_controller!);
        });
      } else {
        _controller = VideoPlayerController.network(
          widget.media!,
          //   videoPlayerOptions: VideoPlayerOptions()
        );

        _controller!.initialize().whenComplete(() {
          _controller!.play();
          setState(() {});
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   TabProvider action = Provider.of<TabProvider>(context, listen: false);
          //   action.changeMultipleImage(widget.media!);
          //   action.addControl(_controller!);
          //      _controller!.play();
          // setState(() {});
          // });
          //    _controller!.play();
          // setState(() {});
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

        _controller!.setLooping(true);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          TabProvider action = Provider.of<TabProvider>(context, listen: false);

          action.addControl(_controller!);
        });
      }
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

    return widget.media!.contains(".mp4")
        ? FeedVideoHolder(
            file: widget.media!,
            controller: _controller!,
            shouldPlay: true,
            isHome: widget.isHome,
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: widget.media!.contains("/data/user/0/")
                        ? FileImage(File(widget.media!))
                        : NetworkImage(
                            widget.media!.replaceAll('\\', '/'),
                          ) as ImageProvider,
                    fit: BoxFit.fill,
                  )),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.0)),
                    ),
                  )),
              Image(
                //  fit: BoxFit.fitWidth,
                width: widget.constraints!.maxWidth,
                image: widget.media!.contains("/data/user/0/")
                    ? FileImage(File(widget.media!))
                    : NetworkImage(
                        widget.media!.replaceAll('\\', '/'),
                      ) as ImageProvider,
              ),
            ],
          );
  }
}
