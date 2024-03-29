import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:macanacki/presentation/screens/home/diamond/diamond_modal/buy_modal.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/middleware/gift_ware.dart';
import 'package:provider/provider.dart';

import '../../services/middleware/feed_post_ware.dart';
import '../constants/colors.dart';
import 'loader.dart';

AlertDialog confirmationDialog({
  String? title,
  String? message,
  String? confirmText,
  String? cancelText,
  IconData? icon,
  VoidCallback? onPressed,
  VoidCallback? onPressedCancel,
  List<Color>? iconColor,
}) {
  return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      backgroundColor: backgroundSecondary,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
                    colors: iconColor ?? [Colors.red, Colors.amber],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter)
                .createShader(bounds),
            child: Icon(
              icon ?? Icons.warning_rounded,
              color: Colors.amber,
              size: 100.0,
            ),
          ),
          SizedBox(height: 30),
          AppText(
            text: title ?? "",
            fontWeight: FontWeight.w800,
            size: 18,
            color: textWhite,
          ),
          AppText(
            text: message ?? "",
            fontWeight: FontWeight.w700,
            size: 14,
            color: textPrimary,
            align: TextAlign.center,
          ),
          Divider(color: Color(0xffededed)),
          RawMaterialButton(
            onPressed: onPressed,
            elevation: 0.0,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Text(
              confirmText ?? "",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xff686868)),
              textAlign: TextAlign.center,
            ),
          ),
          Divider(color: Color(0xffededed)),
          RawMaterialButton(
            onPressed: onPressedCancel ??
                () {
                  Get.back();
                },
            constraints: BoxConstraints.tightForFinite(width: double.maxFinite),
            elevation: 0.0,
            focusColor: Color(0xfff8f8f8),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Text(
              cancelText ?? "",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xffdd2a2a)),
            ),
          ),
        ],
      ));
}

AlertDialog verifiedDialog({
  String? title,
  String? message,
  String? confirmText,
  String? cancelText,
  VoidCallback? onPressed,
  VoidCallback? onPressedCancel,
}) {
  return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          SizedBox(
              height: 50,
              width: 50,
              child: Lottie.asset(
                "assets/icon/verified_anim.json",
              )),
          SizedBox(height: 30),
          Text(
            title ?? "",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          Text(
            message ?? "",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Color(0xff979797)),
            textAlign: TextAlign.center,
          ),
          Divider(color: Color(0xffededed)),
          RawMaterialButton(
            onPressed: onPressed,
            elevation: 0.0,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Text(
              confirmText ?? "",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xff686868)),
              textAlign: TextAlign.center,
            ),
          ),
          Divider(color: Color(0xffededed)),
          RawMaterialButton(
            onPressed: onPressedCancel ??
                () {
                  Get.back();
                },
            constraints: BoxConstraints.tightForFinite(width: double.maxFinite),
            elevation: 0.0,
            focusColor: Color(0xfff8f8f8),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Text(
              cancelText ?? "",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xffdd2a2a)),
            ),
          ),
        ],
      ));
}

AlertDialog diamondDialog(
    {String? title,
    String? message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onPressed,
    VoidCallback? onPressedCancel,
    bool? isFail,
    BuildContext? context}) {
  return AlertDialog(
      backgroundColor: HexColor(backgroundColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          SizedBox(
              height: 50,
              width: 50,
              child: SvgPicture.asset(
                "assets/icon/diamond.svg",
                // color: isFail == true ? Colors.red : null,
              )),
          SizedBox(height: 30),
          AppText(
            text: title ?? "",
            size: 18,
            fontWeight: FontWeight.w800,
            color: textWhite,
          ),
          Text(
            message ?? "",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Color(0xff979797)),
            textAlign: TextAlign.center,
          ),
          Divider(color: Color(0xffededed)),
          RawMaterialButton(
            onPressed: onPressed ??
                () {
                  if (isFail == true) {
                    Get.back();
                    // buyDiamondsModal(
                    //     context!, GiftWare.instance.rate.value.data);
                  } else {
                    Get.back();
                  }
                },
            elevation: 0.0,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Text(
              confirmText ?? "",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xff686868)),
              textAlign: TextAlign.center,
            ),
          ),
          Divider(color: Color(0xffededed)),
          RawMaterialButton(
            onPressed: onPressedCancel ??
                () {
                  if (isFail == true) {
                    Get.back();
                    buyDiamondsModal(
                        context!, GiftWare.instance.rate.value.data);
                  } else {
                    Get.back();
                  }
                },
            constraints: BoxConstraints.tightForFinite(width: double.maxFinite),
            elevation: 0.0,
            focusColor: Color(0xfff8f8f8),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Text(
              cancelText ?? "",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xffdd2a2a)),
            ),
          ),
        ],
      ));
}

AlertDialog bankDialog(
    {String? title,
    String? message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onPressed,
    VoidCallback? onPressedCancel,
    bool? isFail}) {
  return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          SizedBox(
              height: 50,
              width: 50,
              child: SvgPicture.asset(
                "assets/icon/bank.svg",
                color: isFail == true ? Colors.red : HexColor(diamondColor),
              )),
          SizedBox(height: 30),
          Text(
            title ?? "",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          Text(
            message ?? "",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Color(0xff979797)),
            textAlign: TextAlign.center,
          ),
          Divider(color: Color(0xffededed)),
          RawMaterialButton(
            onPressed: onPressed,
            elevation: 0.0,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Text(
              confirmText ?? "",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xff686868)),
              textAlign: TextAlign.center,
            ),
          ),
          Divider(color: Color(0xffededed)),
          RawMaterialButton(
            onPressed: onPressedCancel ??
                () {
                  Get.back();
                },
            constraints: BoxConstraints.tightForFinite(width: double.maxFinite),
            elevation: 0.0,
            focusColor: Color(0xfff8f8f8),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Text(
              cancelText ?? "",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xffdd2a2a)),
            ),
          ),
        ],
      ));
}

AlertDialog seeWebsiteDialog(
    {String? title,
    String? message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onPressed,
    VoidCallback? onPressedCancel,
    bool? isFail,
    BuildContext? context,
    String? svg}) {
  return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      backgroundColor: backgroundSecondary,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          SizedBox(
              height: 50,
              width: 50,
              child: SvgPicture.asset(
                "assets/icon/$svg.svg",
                color: textWhite,
                // color: isFail == true ? Colors.red : null,
              )),
          SizedBox(height: 30),
          AppText(
            text: title ?? "",
            size: 18,
            fontWeight: FontWeight.w800,
            color: textWhite,
          ),
          AppText(
            text: message ?? "",
            size: 14,
            fontWeight: FontWeight.w800,
            color: textPrimary,
            align: TextAlign.center,
          ),

          // Divider(color: Color(0xffededed)),
          // RawMaterialButton(
          //   onPressed: onPressed ??
          //       () {
          //         if (isFail == true) {
          //           Get.back();
          //           // buyDiamondsModal(
          //           //     context!, GiftWare.instance.rate.value.data);
          //         } else {
          //           Get.back();
          //         }
          //       },
          //   elevation: 0.0,
          //   padding:
          //       const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          //   shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(12.0)),
          //   child: Text(
          //     confirmText ?? "",
          //     style: TextStyle(
          //         fontWeight: FontWeight.w600,
          //         fontSize: 14,
          //         color: Color(0xff686868)),
          //     textAlign: TextAlign.center,
          //   ),
          // ),

          Divider(color: Color(0xffededed)),
          RawMaterialButton(
            onPressed: onPressedCancel ??
                () {
                  if (isFail == true) {
                    Get.back();
                  } else {
                    Get.back();
                  }
                },
            constraints: BoxConstraints.tightForFinite(width: double.maxFinite),
            elevation: 0.0,
            focusColor: Color(0xfff8f8f8),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Text(
              cancelText ?? "",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xffdd2a2a)),
            ),
          ),
        ],
      ));
}

AlertDialog CrownDialogue(
    {String? title,
    String? message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onPressed,
    VoidCallback? onPressedCancel,
    bool? isFail,
    BuildContext? context,
    FeedPostWare? feed,
    String? svg}) {
  return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      backgroundColor: backgroundSecondary,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          SizedBox(
              height: 50,
              width: 50,
              child: SvgPicture.asset(
                "assets/icon/$svg.svg",
                color: textWhite,
                // color: isFail == true ? Colors.red : null,
              )),
          SizedBox(height: 30),
          AppText(
            text: title ?? "",
            size: 18,
            fontWeight: FontWeight.w800,
            color: textWhite,
          ),
          SizedBox(height: 10),
          AppText(
            text: message ?? "",
            size: 14,
            fontWeight: FontWeight.w800,
            color: textPrimary,
            align: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: Color(0xffededed)),
          ),
          feed!.loadNg
              ? Loader(color: textPrimary)
              : RawMaterialButton(
                  onPressed: onPressed ??
                      () {
                        Get.back();
                      },
                  elevation: 0.0,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Text(
                    confirmText ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: textWhite),
                    textAlign: TextAlign.center,
                  ),
                ),
          Divider(color: Color(0xffededed)),
          RawMaterialButton(
            onPressed: onPressedCancel ??
                () {
                  if (isFail == true) {
                    Get.back();
                  } else {
                    Get.back();
                  }
                },
            constraints: BoxConstraints.tightForFinite(width: double.maxFinite),
            elevation: 0.0,
            focusColor: Color(0xfff8f8f8),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Text(
              cancelText ?? "",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xffdd2a2a)),
            ),
          ),
        ],
      ));
}
