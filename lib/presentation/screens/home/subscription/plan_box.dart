import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/widgets/text.dart';

class PlanBox extends StatelessWidget {
  final SubPlans plans;
  const PlanBox({super.key, required this.plans});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 151,
      width: 128,
      decoration: BoxDecoration(
          color:
              plans.isPopular ? HexColor(backgroundColor) : HexColor("#F5F2F9"),
          shape: BoxShape.rectangle,
          border: Border.all(
            color:
                plans.isPopular ? HexColor(primaryColor) : HexColor("#F5F2F9"),
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
              plans.isPopular
                  ? Container(
                      width: 106,
                      height: 19,
                      decoration: BoxDecoration(
                          color: HexColor(primaryColor),
                          shape: BoxShape.rectangle,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(11.5),
                              bottomRight: Radius.circular(11.5))),
                      child: Center(
                        child: AppText(
                          text: "MOST POPULAR",
                          color: HexColor(backgroundColor),
                          size: 11,
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
                      text: plans.duration == "6 Months"
                          ? "6"
                          : plans.duration == "3 Months"
                              ? "3"
                              : "12",
                      color: plans.duration == "6 Months"
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
                      color: plans.duration == "6 Months"
                          ? HexColor(primaryColor)
                          : HexColor(darkColor),
                      size: 16,
                      fontWeight: FontWeight.w400,
                      align: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              AppText(
                text: plans.amount,
                size: 14,
                fontWeight: FontWeight.w400,
                color: plans.duration == "6 Months"
                    ? HexColor("#FFC1D6")
                    : HexColor("#C0C0C0"),
                align: TextAlign.center,
              ),
              const SizedBox(
                height: 15,
              ),
              AppText(
                text: plans.discount,
                size: 16,
                fontWeight: FontWeight.w400,
                color: plans.duration == "6 Months"
                    ? HexColor("##F94C84")
                    : HexColor("#5F5F5F"),
                align: TextAlign.center,
              )
            ],
          )
        ],
      ),
    );
  }
}
