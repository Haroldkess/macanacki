import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/widgets/text.dart';

Future<void> showToast(
    BuildContext context, String message, Color textColor) async {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: TextStyle(
          color: textColor.withOpacity(0.6),
          fontWeight: FontWeight.w400,
          fontSize: 16.0),
    ),
    elevation: 20,
    behavior: SnackBarBehavior.floating,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    width: MediaQuery.of(context).size.width * 0.8,
    backgroundColor: Colors.white,
  ));
}

//  MotionToast(
//     icon: Icons.zoom_out,
//     //color:  Colors.deepOrange,
//     title: AppText(text: "Alert"),
//     description: AppText(text: message),
//     position: MotionToastPosition.top,
//     animationType: AnimationType.fromTop, primaryColor: textColor,
//   ).show(context);

showToast2(BuildContext context, String message, {bool isError = false}) async {
  await showStyledToast(
    
  child:    SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Material(
          color: isError ? Colors.white : HexColor(primaryColor),
          elevation: 10,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: isError ? Colors.red : Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: isError
                      ? const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 42,
                        )
                      : Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: HexColor(backgroundColor)),
                          child: Center(
                              child: SvgPicture.asset(
                            'assets/icon/crown.svg',
                            color: HexColor(primaryColor),
                          )),
                        ),
                ),
                Expanded(
                  child: AppText(
                      text: message,
                      color: isError ? Colors.red : Colors.white,
                      size: 12),
                ),
              ],
            ),
          ),
        ),
      ),
     
  context: context,
  alignment: Alignment.topCenter,
  backgroundColor: Colors.transparent,
  animationBuilder: (context, animation, child) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }
);

  // showToastWidget(
  //     SizedBox(
  //       width: MediaQuery.of(context).size.width * 0.9,
  //       child: Material(
  //         color: isError ? Colors.white : HexColor(primaryColor),
  //         elevation: 10,
  //         borderRadius: BorderRadius.circular(10),
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //           child: Row(
  //             children: [
  //               Container(
  //                 width: 4,
  //                 height: 50,
  //                 decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(5),
  //                     color: isError ? Colors.red : Colors.white),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 10),
  //                 child: isError
  //                     ? const Icon(
  //                         Icons.error,
  //                         color: Colors.red,
  //                         size: 42,
  //                       )
  //                     : Container(
  //                         height: 32,
  //                         width: 32,
  //                         decoration: BoxDecoration(
  //                             shape: BoxShape.circle,
  //                             color: HexColor(backgroundColor)),
  //                         child: Center(
  //                             child: SvgPicture.asset(
  //                           'assets/icon/crown.svg',
  //                           color: HexColor(primaryColor),
  //                         )),
  //                       ),
  //               ),
  //               Expanded(
  //                 child: AppText(
  //                     text: message,
  //                     color: isError ? Colors.red : Colors.white,
  //                     size: 12),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
     
     
  //     animation: StyledToastAnimation.slideFromTop,
  //     duration: const Duration(seconds: 4),
  //     position:
  //         const StyledToastPosition(align: Alignment.topCenter, offset: 40.0),
  //     reverseCurve: Curves.easeInCubic,
  //     context: context);
}


Future<void> showToastLater (msg) async {
   await Fluttertoast.showToast(
              msg: msg,
              textColor: HexColor(backgroundColor),
              gravity: ToastGravity.TOP,
              backgroundColor: HexColor(primaryColor));
}