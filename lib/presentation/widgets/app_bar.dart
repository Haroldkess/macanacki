import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/screens/notification/notification_screen.dart';

import '../constants/colors.dart';
import '../constants/params.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final Color color;
  const AppHeader({super.key, required this.color});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: color,
      child: PreferredSize(
        preferredSize: Size(width, 27),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              //  top: horizontalPadding ,
              left: 24,
              right: 24,
            ),
            child: Container(
              color: color,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  myIcon("assets/icon/makanakiicon.svg", primaryColor, 16.52,
                      70, false),
                  InkWell(
                    onTap: () => PageRouting.pushToPage(
                        context, const NotificationScreen()),
                    child: myIcon("assets/icon/notification.svg", "#828282",
                        19.13, 17.31, true),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget myIcon(String svgPath, String hexString, double height, double width,
      bool isNotification) {
    return Stack(
      children: [
        SvgPicture.asset(
          svgPath,
          height: height,
          width: width,
          color: HexColor(hexString),
        ),
        isNotification
            ? const Positioned(
                right: 2.0,
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.red,
                ),
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
