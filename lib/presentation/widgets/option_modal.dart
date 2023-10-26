import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/model/ui_model.dart';
import 'package:macanacki/presentation/screens/home/subscription/subscrtiption_plan.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/presentation/widgets/loader.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/controllers/create_post_controller.dart';
import 'package:macanacki/services/controllers/plan_controller.dart';
import 'package:macanacki/services/controllers/save_media_controller.dart';
import 'package:macanacki/services/middleware/plan_ware.dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
import 'package:provider/provider.dart';
import '../../model/feed_post_model.dart';
import '../screens/home/diamond/diamond_modal/download_modal.dart';
import '../screens/home/profile/createpost/edit_post.dart';

optionModal(BuildContext cont, List<String> url,
    [int? id, int? postId, FeedPost? data]) async {
  bool pay = true;
  return showModalBottomSheet(
      context: cont,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        PlanWare stream = context.watch<PlanWare>();
        UserProfileWare user = context.watch<UserProfileWare>();
        // PlanWare action = Provider.of<PlanWare>(context,listen: false);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                stream.loadStatus
                    ? Loader(color: HexColor(primaryColor))
                    : Column(
                        // mainAxisSize: MainAxisSize.min,
                        children: user.userProfileModel.id == id
                            ? userFeedOption
                                .map((e) => ListTile(
                                      onTap: () async {
                                        UserProfileWare user =
                                            Provider.of<UserProfileWare>(
                                                context,
                                                listen: false);
                                        if (e.id == 0) {
                                          // if (user.userProfileModel.activePlan ==
                                          //     "inactive subscription") {
                                          //   await PlanController
                                          //       .retrievPlanController(context);
                                          // } else {
                                          //   emitter(data!.user!.username!);
                                          if (data!.user!.username! ==
                                              user.userProfileModel.username) {
                                            if (data.media!.length > 1) {
                                              await Future.forEach(data.media!,
                                                  (element) async {
                                                if (element.isNotEmpty) {
                                                  try {
                                                    if (element
                                                        .contains('.mp4')) {
                                                      await SaveMediaController
                                                          .saveNetworkVideo(
                                                              context, element);
                                                    } else if (element
                                                        .contains('.mp3')) {
                                                      await SaveMediaController
                                                          .saveNetworkAudio(
                                                              context, element);
                                                    } else {
                                                      await SaveMediaController
                                                          .saveNetworkImage(
                                                              context, element);
                                                    }
                                                  } catch (e) {
                                                    debugPrint(e.toString());
                                                  }
                                                }
                                              });
                                            } else {
                                              if (data.media!.first
                                                  .contains('.mp4')) {
                                                await SaveMediaController
                                                    .saveNetworkVideo(context,
                                                        data.media!.first);
                                              } else if (data.media!.first
                                                  .contains('.mp3')) {
                                                await SaveMediaController
                                                    .saveNetworkAudio(context,
                                                        data.media!.first);
                                              } else {
                                                await SaveMediaController
                                                    .saveNetworkImage(context,
                                                        data.media!.first);
                                              }
                                            }
                                          } else {
                                            downloadDiamondsModal(
                                              context,
                                              postId!,
                                            );
                                          }

                                          // }
                                        } else if (e.id == 3) {
                                          PageRouting.pushToPage(
                                              context,
                                              EditPostScreen(
                                                  media: url.first,
                                                  id: postId!));
                                        } else if (e.id == 4) {
                                        //  print(postId);
                                          PageRouting.popToPage(context);

                                          ScaffoldMessenger.of(cont)
                                              .showSnackBar(SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            duration:
                                                const Duration(seconds: 5),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            elevation: 10.0,
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                left: 15,
                                                right: 3),
                                            content: Row(
                                              children: [
                                                AppText(
                                                  text:
                                                      "Sure you want to delete?",
                                                  color: Colors.white,
                                                  size: 15,
                                                  fontWeight: FontWeight.w600,
                                                )
                                              ],
                                            ),
                                            backgroundColor:
                                                HexColor(primaryColor)
                                                    .withOpacity(.9),
                                            action: SnackBarAction(
                                                label: "Yes",
                                                textColor: Colors.white,
                                                onPressed: () async {
                                                  await CreatePostController
                                                      .deletePost(cont, postId);

                                                  // PageRouting.popToPage(
                                                  //     cont);
                                                }),
                                          ));
                                        }
                                      },
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: AppText(
                                          text: e.name,
                                          color: HexColor(darkColor),
                                          size: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ))
                                .toList()
                            : feedOption
                                .map((e) => ListTile(
                                      onTap: () async {
                                        UserProfileWare user =
                                            Provider.of<UserProfileWare>(
                                                context,
                                                listen: false);
                                        if (e.id == 0) {
                                          // if (user.userProfileModel.activePlan ==
                                          //     "inactive subscription") {
                                          //   await PlanController
                                          //       .retrievPlanController(context);
                                          // } else {
                                          if (data!.user!.username! ==
                                              user.userProfileModel.username) {
                                            if (data.media!.length > 1) {
                                              await Future.forEach(data.media!,
                                                  (element) async {
                                                if (element.isNotEmpty) {
                                                  try {
                                                    if (element
                                                        .contains('.mp4')) {
                                                      await SaveMediaController
                                                          .saveNetworkVideo(
                                                              context, element);
                                                    } else {
                                                      await SaveMediaController
                                                          .saveNetworkImage(
                                                              context, element);
                                                    }
                                                  } catch (e) {
                                                    debugPrint(e.toString());
                                                  }
                                                }
                                              });
                                            } else {
                                              if (data.media!.first
                                                  .contains('.mp4')) {
                                                await SaveMediaController
                                                    .saveNetworkVideo(context,
                                                        data.media!.first);
                                              } else {
                                                await SaveMediaController
                                                    .saveNetworkImage(context,
                                                        data.media!.first);
                                              }
                                            }
                                          } else {
                                            downloadDiamondsModal(
                                              context,
                                              postId!,
                                            );
                                          }

                                          // }
                                        }
                                      },
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: AppText(
                                          text: e.name,
                                          color: HexColor(darkColor),
                                          size: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ))
                                .toList(),
                      )
              ],
            ),
          ),
        );
      });
}
