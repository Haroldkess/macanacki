import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../../model/feed_post_model.dart';
import '../../../services/controllers/view_controller.dart';
import '../../../services/middleware/post_security.dart';
import '../../allNavigation.dart';
import '../../constants/string.dart';
import '../../screens/home/Feed/feed_video_holder.dart';
import '../../uiproviders/screen/tab_provider.dart';
import '../debug_emitter.dart';
import '../loader.dart';
import 'image_holder.dart';

class MultiplePost extends StatelessWidget {
  final List<String>? media;
  final BoxConstraints? constraints;
  final FeedPost? data;
  final bool isHome;
  final List<String>? thumbLinks;
  bool? isInView;

  MultiplePost(
      {super.key,
      this.media,
      this.constraints,
      required this.data,
      required this.isHome,
      required this.thumbLinks,
      required this.isInView});

  @override
  Widget build(BuildContext context) {
    TabProvider stream = context.watch<TabProvider>();
    //  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    // PostSecurity.instance.toggleSecure(true);
    // });
    return Stack(
      children: [
        PageView.builder(
          itemCount: media!.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return MultipleView(
              data: data!,
              media: media![index],
              constraints: constraints,
              index: index,
              isHome: isHome,
              thumbLink: thumbLinks![index],
              isInView: isInView,
              images: media!,
            );
          },
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            const   SizedBox(
                height:
                    100,
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

class MultipleView extends StatefulWidget {
  final String? media;
  final BoxConstraints? constraints;
  final FeedPost data;
  final int index;
  final bool isHome;
  final String thumbLink;
  bool? isInView;
  final List<String> images;

  MultipleView(
      {super.key,
      this.media,
      this.constraints,
      required this.data,
      required this.index,
      required this.isHome,
      required this.thumbLink,
      required this.isInView,
      required this.images});

  @override
  State<MultipleView> createState() => _MultipleViewState();
}

class _MultipleViewState extends State<MultipleView> {
  @override
  void initState() {
    super.initState();
    if (!widget.media!.contains("https")) {
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
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return !widget.media!.contains("https")
        ? FeedVideoHolder(
            file: "$muxStreamBaseUrl/${widget.media}.$videoExtension",
            shouldPlay: true,
            isHome: widget.isHome,
            thumbLink: widget.thumbLink,
            isInView: widget.isInView!,
            page: 'feed',
            postId: widget.data.id!,
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
                    width: double.infinity,
                    //   color: Colors.amber,
                    child: CachedNetworkImage(
                      imageUrl: widget.media!.replaceAll('\\', '/'),
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
                      errorWidget: (context, url, error) => CachedNetworkImage(
                          imageUrl: widget.media!.replaceAll('\\', '/'),
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
                            return SizedBox();
                          }),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
