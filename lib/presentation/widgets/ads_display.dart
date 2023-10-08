import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/widgets/text.dart';

class AdsDisplay extends StatelessWidget {
  final Color? color;
  final String? title;
  VoidCallback? action;
  bool sponsored;
  AdsDisplay(
      {super.key,
      this.color,
      this.action,
      this.title,
      required this.sponsored});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: sponsored ? 110 : 77, minWidth: 77),
        height: 30,
        decoration: BoxDecoration(
            color: color,
            borderRadius: title == "PROMOTE"
                ? const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  )),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              AppText(
                text: title!,
                color: HexColor(backgroundColor),
                size: 10,
                fontWeight: FontWeight.w600,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
