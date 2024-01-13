import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macanacki/presentation/constants/colors.dart';

import '../../presentation/widgets/text.dart';

AlertDialog seeDialog(
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
              child: isFail == true
                  ? CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                    )
                  : CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    )

              //  SvgPicture.asset(
              //   "assets/icon/$svg.svg",
              //   color: textWhite,
              //   // color: isFail == true ? Colors.red : null,
              // )

              ),
          SizedBox(height: 20),
          AppText(
            text: title ?? "",
            size: 18,
            fontWeight: FontWeight.w800,
            color: textWhite,
          ),
          SizedBox(height: 5),
          AppText(
            text: message ?? "",
            size: 13,
            fontWeight: FontWeight.w800,
            color: textPrimary,
            align: TextAlign.center,
          ),
          Divider(color: Color(0xffededed)),
          RawMaterialButton(
            onPressed: onPressed ??
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
              confirmText ?? "",
              style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 14, color: textWhite),
            ),
          ),
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
