import 'package:flutter/material.dart';
import 'package:macanacki/presentation/model/ui_model.dart';
import 'package:macanacki/presentation/screens/home/convo/matchedextra/matched_boxes.dart';

class MatchedGrid extends StatelessWidget {
  const MatchedGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: matchedUsers.length,
      padding: const EdgeInsets.symmetric(horizontal: 17),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 11.0,
          mainAxisSpacing: 11.0,
          mainAxisExtent: 200),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        AppUser matches = matchedUsers[index];

        return MatchedBox(
          matches: matches,
        );
      },
    );
  }
}
