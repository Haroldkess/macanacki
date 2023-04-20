import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';

class Avatar extends StatelessWidget {
  final String image;
  final double radius;
  const Avatar({super.key, required this.image, required this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: HexColor(primaryColor),
      backgroundImage: CachedNetworkImageProvider(image),
    );
  }
}
