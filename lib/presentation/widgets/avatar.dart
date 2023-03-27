import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String image;
  final double radius;
  const Avatar({super.key, required this.image, required this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(image),
    );
  }
}
