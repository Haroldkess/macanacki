import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/operations.dart';
import 'package:macanacki/services/controllers/feed_post_controller.dart';
import 'package:macanacki/services/middleware/ads_ware.dart';
import 'package:provider/provider.dart';
import 'package:cached_video_preview/cached_video_preview.dart';
import '../../../../../model/profile_feed_post.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/params.dart';
import '../../../../widgets/text.dart';

Future selectPost(BuildContext context, List<ProfileFeedDatum> post) async {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              //   height: MediaQuery.of(context).size.height / 2,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          AppText(
                            text: "Select Post",
                            color: HexColor(darkColor),
                            size: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: post
                          .map((e) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                child: InkWell(
                                  onTap: () async {
                                    Navigator.pop(context, e);
                                  },
                                  child: SizedBox(
                                    //  height: 30,
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              e.media!.first.contains("https")
                                                  ? Container(
                                                      width: 70,
                                                      height: 70,
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          image:
                                                              DecorationImage(
                                                            image:
                                                                CachedNetworkImageProvider(
                                                              e.media!.first
                                                                  .replaceAll(
                                                                      '\\',
                                                                      '/'),
                                                            ),
                                                            fit: BoxFit.fill,
                                                          )),
                                                    )
                                                  : Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Container(
                                                          width: 70,
                                                          height: 70,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.black,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          child:
                                                              CachedVideoPreviewWidget(
                                                            path:
                                                                e.media!.first,
                                                            type: SourceType
                                                                .remote,
                                                            remoteImageBuilder:
                                                                (BuildContext
                                                                            context,
                                                                        url) =>
                                                                    Image.network(
                                                                        url),
                                                          ),
                                                        ),
                                                        Icon(Icons.play_arrow,
                                                            size: 14,
                                                            color: Colors.grey)
                                                      ],
                                                    ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppText(
                                                text: e.description ?? "",
                                                fontWeight: FontWeight.w500,
                                                size: 14,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ));
}
