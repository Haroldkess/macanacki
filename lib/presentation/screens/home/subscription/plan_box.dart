import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/middleware/plan_ware.dart';
import 'package:provider/provider.dart';

import '../../../../model/plan_model.dart';

class PlanBox extends StatelessWidget {
  final PlanData plans;
  int index;
  PlanBox({super.key, required this.plans, required this.index});

  @override
  Widget build(BuildContext context) {
    PlanWare stream = context.watch<PlanWare>();

    return InkWell(
      onTap: () async {
        PlanWare ware = Provider.of<PlanWare>(context, listen: false);
        ware.selectPlan(index);
        ware.addAmount(plans.amountInNaira!.toInt());
      },
      child: Container(
        height: 151,
        width: 103,
        decoration: BoxDecoration(
            color: plans.mostPopular == 1
                ? HexColor(backgroundColor)
                : HexColor("#F5F2F9"),
            shape: BoxShape.rectangle,
            border: Border.all(
              color: stream.index == index
                  ? HexColor(primaryColor)
                  : HexColor("#F5F2F9"),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                plans.mostPopular == 1
                    ? Container(
                        width: 95,
                        height: 19,
                        decoration: BoxDecoration(
                            color: HexColor(primaryColor),
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(11.5),
                              bottomRight: Radius.circular(11.5),
                              topLeft: Radius.circular(5.5),
                              topRight: Radius.circular(5.5),
                            )),
                        child: Center(
                          child: AppText(
                            text: "MOST POPULAR",
                            color: HexColor(backgroundColor),
                            size: 8,
                            fontWeight: FontWeight.w400,
                            align: TextAlign.center,
                          ),
                        ),
                      )
                    : const SizedBox(
                        width: 106,
                        height: 19,
                      ),
                const SizedBox(
                  height: 6,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: AppText(
                        text: plans.duration.toString(),
                        color: plans.mostPopular == 1
                            ? HexColor(primaryColor)
                            : HexColor(darkColor),
                        size: 32,
                        fontWeight: FontWeight.w600,
                        align: TextAlign.center,
                      ),
                    ),
                    Center(
                      child: AppText(
                        text: "Months",
                        color: plans.mostPopular == 1
                            ? HexColor(primaryColor)
                            : HexColor(darkColor),
                        size: 14,
                        fontWeight: FontWeight.w600,
                        align: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                AppText(
                  text: "\$${plans.amount.toString()}",
                  size: 12,
                  fontWeight: FontWeight.w600,
                  color: plans.mostPopular == 1
                      ? HexColor("#222222")
                      : HexColor("#C0C0C0"),
                  align: TextAlign.center,
                ),
                const SizedBox(
                  height: 15,
                ),
                AppText(
                  text: index == 1
                      ? 'SAVE 20%'
                      : index == 2
                          ? "SAVE 30%"
                          : "",
                  size: 13,
                  fontWeight: FontWeight.w500,
                  color: plans.mostPopular == 1
                      ? HexColor("##F94C84")
                      : HexColor("#5F5F5F"),
                  align: TextAlign.center,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
