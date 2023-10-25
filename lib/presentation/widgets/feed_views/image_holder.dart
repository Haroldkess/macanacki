
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../../../../model/feed_post_model.dart';
import '../../allNavigation.dart';
import 'new_action_design.dart';

class EnlargeImageHolder extends StatefulWidget {
  List<String> images;

  final String page;

  final FeedPost data;
  int index;

  EnlargeImageHolder(
      {super.key,
      required this.images,
      required this.page,
      required this.data,
      required this.index});

  @override
  State<EnlargeImageHolder> createState() => _EnlargeImageHolderState();
}

class _EnlargeImageHolderState extends State<EnlargeImageHolder> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> innit() async {}

  @override
  void dispose() {
    super.dispose();
  }

  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    PageController controller = PageController(initialPage: widget.index);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
              height: double.infinity,
              width: double.infinity,
              child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: CachedNetworkImageProvider(
                      widget.images[index],
                    ),
                    initialScale: PhotoViewComputedScale.contained,
                    heroAttributes:
                        PhotoViewHeroAttributes(tag: widget.images[index]),
                  );
                },
                itemCount: widget.images.length,
                loadingBuilder: (context, event) => Center(
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      value: event == null
                          ? 0
                          : event.cumulativeBytesLoaded /
                              event.expectedTotalBytes!,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(HexColor(primaryColor)),
                    ),
                  ),
                ),
                backgroundDecoration: BoxDecoration(color: Colors.black),
                pageController: controller,
                onPageChanged: (index) {},
              )),
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 5),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                  onPressed: () => PageRouting.popToPage(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
            ),
          ),
         
          Align(
            alignment: Alignment.bottomLeft,
            child: VideoUser(
              page: widget.page,
              data: widget.data,
              isHome: true,
              media: [],
            ),
          ),
    
        
        ],
      ),
    );
  }
}

class ImageHolder extends StatefulWidget {
  List<String> images;
  ImageHolder({
    super.key,
    required this.images,
  });

  @override
  State<ImageHolder> createState() => _ImageHolderState();
}

class _ImageHolderState extends State<ImageHolder> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> innit() async {}

  @override
  void dispose() {
    super.dispose();
  }

  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    PageController controller = PageController(initialPage: 0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
              height: double.infinity,
              width: double.infinity,
              child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: CachedNetworkImageProvider(
                      widget.images[index],
                    ),
                    initialScale: PhotoViewComputedScale.contained,
                    heroAttributes:
                        PhotoViewHeroAttributes(tag: widget.images[index]),
                  );
                },
                itemCount: widget.images.length,
                loadingBuilder: (context, event) => Center(
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      value: event == null
                          ? 0
                          : event.cumulativeBytesLoaded /
                              event.expectedTotalBytes!,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(HexColor(primaryColor)),
                    ),
                  ),
                ),
                backgroundDecoration: BoxDecoration(color: Colors.black),
                pageController: controller,
                onPageChanged: (index) {},
              )),
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 5),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                  onPressed: () => PageRouting.popToPage(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
            ),
          ),


        
        ],
      ),
    );
  }
}
