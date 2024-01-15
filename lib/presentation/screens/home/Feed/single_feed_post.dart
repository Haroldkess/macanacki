import 'dart:convert';

// import 'package:inview_notifier_list/inview_notifier_list.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:macanacki/presentation/widgets/loader.dart';
import 'package:macanacki/presentation/widgets/text.dart';

import 'package:macanacki/presentation/widgets/tik_tok_view.dart';
import 'package:macanacki/services/backoffice/feed_post_office.dart';
import 'package:path/path.dart';
import 'package:preload_page_view/preload_page_view.dart';

import '../../../../model/feed_post_model.dart';

import '../../../../model/single_post_model.dart' hide Comment;
import '../../../constants/colors.dart';

import '../../../operations.dart';
import '../../../widgets/debug_emitter.dart';

class SingleFeedPost extends StatefulWidget {
  SingleFeedPost({
    super.key,
  });

  @override
  State<SingleFeedPost> createState() => _SingleFeedPostState();
}

class _SingleFeedPostState extends State<SingleFeedPost> {
  PageController? controller;
  FeedPost singlePost = FeedPost();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    Operations.controlSystemColor();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      String id = ModalRoute.of(this.context)!.settings.arguments.toString();

      getFromApi(id);
    });
  }

  @override
  Widget build(BuildContext context) {
//    controller = PageController(initialPage: stream.index, keepPage: true);
    PreloadPageController controller =
        PreloadPageController(initialPage: 1, keepPage: true);

    return SafeArea(
        child: Scaffold(
      backgroundColor: HexColor(backgroundColor),
      body: Container(
        color: HexColor(backgroundColor),
        height: Get.height,
        width: Get.width,
        child: isLoading
            ? Center(
                child: Loader(color: textWhite),
              )
            : singlePost.id == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          BackButton(
                            color: textWhite,
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            size: 50,
                            color: Colors.redAccent,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          AppText(
                            text: "Post not found",
                            color: textPrimary,
                            size: 14,
                          )
                        ],
                      ),
                      SizedBox()
                    ],
                  )
                : TikTokView(
                    media: singlePost.mux!,
                    vod: singlePost.vod!,
                    data: singlePost,
                    isFriends: false,
                    page: "single",
                    urls: singlePost.media!,
                    thumbails: singlePost.thumbnails!,
                    isHome: false,
                    isInView: true,
                    nextImage: null,
                  ),
      ),
    ));
  }

  Future<bool> getFromApi(String id) async {
    late bool isSuccessful;

    emitter("this is the id $id");
    setState(() {
      isLoading = true;
    });
    try {
      http.Response? response = await getSinglePostPost(id)
          .whenComplete(() => emitter(" gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        //  log("get gender request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        try {
          var post = SingleFeedPostModel.fromJson(jsonData);

          emitter(post.toJson().toString());

          List<Comment> talks = [];
          if (post.data!.comments!.isNotEmpty) {}

          Future.forEach(post.data!.comments!, (element) {
            Comment comment = Comment(
                id: element.id,
                body: element.body,
                createdAt: element.createdAt,
                updatedAt: element.updatedAt,
                username: element.username,
                profilePhoto: element.profilePhoto,
                noOfLikes: element.noOfLikes,
                postId: element.postId);

            talks.add(comment);
          });

          final User user = User(
              id: post.data!.user!.id,
              //  email: post.data!.user!.email,
              username: post.data!.user!.username,
              //  faceVerification: post.data!.user!.faceVerification,
              //  dob: post.data!.user!.dob,
              // emailVerified: post.data!.user!.emailVerified,
              //  registrationComplete: post.data!.user!.registrationComplete,
              // emailVerifiedAt: post.data!.user!.emailVerifiedAt,
              createdAt: post.data!.user!.createdAt,
              updatedAt: post.data!.user!.updatedAt,
              //  gender: post.data!.user!.gender,
              profilephoto: post.data!.user!.profilephoto,
              // noOfFollowers: post.data!.user!.noOfFollowers,
              //  noOfFollowing: post.data!.user!.noOfFollowing,
              verified: post.data!.user!.verified!);

          final FeedPost data = FeedPost(
              id: post.data!.id,
              description: post.data!.description,
              published: post.data!.published,
              createdAt: post.data!.createdAt,
              updatedAt: post.data!.updatedAt,
              creator: post.data!.creator,
              media: post.data!.media,
              comments: talks,
              noOfLikes: post.data!.noOfLikes,
              user: user,
              btnLink: post.data!.btnLink,
              button: post.data!.button,
              thumbnails: post.data!.thumbnails,
              viewCount: post.data!.viewCount,
              mux: post.data!.mux,
              vod: post.data!.vod,
              promoted: post.data!.promoted);

          emitter(data.media.toString());

          setState(() {
            singlePost = data;
          });
        } catch (e) {
          emitter(e.toString());
        }

        isSuccessful = true;
      } else {
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      emitter(e.toString());
    }

    setState(() {
      isLoading = false;
    });

    return isSuccessful;
  }

  // @override
  // bool get wantKeepAlive => true;
}
