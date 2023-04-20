import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/screens/home/subscription/subscrtiption_plan.dart';
import 'package:makanaki/presentation/widgets/loader.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/controllers/plan_controller.dart';
import 'package:makanaki/services/controllers/save_media_controller.dart';
import 'package:makanaki/services/middleware/plan_ware.dart';
import 'package:makanaki/services/middleware/user_profile_ware.dart';
import 'package:provider/provider.dart';

optionModal(BuildContext context, String url) async {
  bool pay = true;
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        PlanWare stream = context.watch<PlanWare>();
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
                        children: feedOption
                            .map((e) => ListTile(
                                  onTap: () async {
                                    UserProfileWare user =
                                        Provider.of<UserProfileWare>(context,
                                            listen: false);
                                    if (e.id == 0) {
                                      if (user.userProfileModel.activePlan ==
                                          "inactive subscription") {
                                        await PlanController
                                            .retrievPlanController(context);
                                      } else {
                                        if (url.contains('.mp4')) {
                                          await SaveMediaController
                                              .saveNetworkVideo(context, url);
                                        } else {
                                          await SaveMediaController
                                              .saveNetworkImage(context, url);
                                        }
                                      }
                                    }
                                  },
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
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
