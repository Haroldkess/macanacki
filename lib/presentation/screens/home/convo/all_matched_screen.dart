import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/screens/home/convo/matchedextra/matched_grid.dart';
import 'package:makanaki/presentation/widgets/text.dart';

class MatchedWithYouScreen extends StatelessWidget {
  const MatchedWithYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#F5F2F9"),
      appBar: AppBar(
        backgroundColor: HexColor(backgroundColor),
        centerTitle: true,
        elevation: 0,
        leading: BackButton(
          color: HexColor("#322929"),
        ),
        title: AppText(
          text: "Matched with you",
          color: HexColor(darkColor),
          fontWeight: FontWeight.w500,
          size: 20,
        ),
      ),
      body: const Padding(
        padding:  EdgeInsets.only(top: 11),
        child:  MatchedGrid(),
      ),
    );
  }
}
