import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/operations.dart';
import 'package:provider/provider.dart';

import '../../../../../services/middleware/facial_ware.dart';
import '../../../../../services/middleware/user_profile_ware.dart';
import '../../../../constants/params.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    var w = (size.width - 4 * 1) / 3;
    UserProfileWare user = context.watch<UserProfileWare>();
    FacialWare facial = context.watch<FacialWare>();
    return Container(
        height: 200,
        color: HexColor(backgroundColor),
        child: Center(
          child: Stack(
            children: [
              HexagonWidget.pointy(
                width: w,
                elevation: 10.0,
                color: Colors.white,
                cornerRadius: 20.0,
                child: AspectRatio(
                  aspectRatio: HexagonType.POINTY.ratio,
                  // child: Image.asset(
                  //   'assets/tram.jpg',
                  //   fit: BoxFit.fitWidth,
                  // ),
                ),
              ),
              HexagonWidget.pointy(
                width: w,
                elevation: 10.0,
                color: HexColor("#5F5F5F"),
                padding: 10,
                cornerRadius: 20.0,
                child: AspectRatio(
                    aspectRatio: HexagonType.POINTY.ratio,
                    child: Center(
                        child: facial.addedDp == null
                            ? CachedNetworkImage(
                                imageUrl: user.userProfileModel.profilephoto ??
                                    "https://icon-library.com/images/no-profile-pic-icon/no-profile-pic-icon-27.jpg")
                            : Image.file(File(facial.addedDp!.path)))),
              ),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () => Operations.changePhotoFromGallery(context),
                  child: SvgPicture.asset(
                    "assets/icon/encrypt.svg",
                    color: HexColor(backgroundColor),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
