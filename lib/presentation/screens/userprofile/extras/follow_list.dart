import 'package:flutter/material.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/screens/userprofile/extras/follow_tile.dart';

class FollowFollowingList extends StatelessWidget {
  const FollowFollowingList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: follower.length,
      itemBuilder: (context, index) {
        Follower followerData = follower[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: FollowTile(
            data: followerData,
          ),
        );
      },
    );
  }
}
