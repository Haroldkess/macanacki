import 'package:flutter/cupertino.dart';


class Loader extends StatelessWidget {
  final Color color;
  const Loader({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      color: color,
    );
  }
}
