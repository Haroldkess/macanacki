import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/model/ui_model.dart';
import 'package:macanacki/presentation/screens/home/subscription/subscrtiption_plan.dart';
import 'package:macanacki/presentation/widgets/loader.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/middleware/plan_ware.dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
import 'package:provider/provider.dart';

List<String> id = [
  "NIN",
  "Drivers license",
  "Passport",
  "Voters card",
  "Id card"
];

idModal(
  BuildContext context,
) async {
  bool pay = true;
  return showModalBottomSheet(
      context: context,
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
                        children: id
                            .map((e) => ListTile(
                                  onTap: () async {
                                    UserProfileWare user =
                                        Provider.of<UserProfileWare>(context,
                                            listen: false);
                                    user.addId(e);
                                    PageRouting.popToPage(context);
                                  },
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: AppText(
                                      text: e,
                                      color: user.id == e
                                          ? Colors.black
                                          : Colors.grey,
                                      size: user.id == e ? 16 : 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ))
                            .toList())
              ],
            ),
          ),
        );
      });
}
