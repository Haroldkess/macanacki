import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/widgets/text.dart';

import '../../../../../services/controllers/user_profile_controller.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 10.0,
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 3),
          content: Row(
            children: [
              AppText(
                text: "Sure you want to proceed ?",
                color: Colors.white,
                size: 15,
                fontWeight: FontWeight.w600,
              )
            ],
          ),
          backgroundColor: HexColor(backgroundColor).withOpacity(.9),
          action: SnackBarAction(
              label: "Yes",
              textColor: Colors.white,
              onPressed: () async {
                UserProfileController.deleteUserProfile(context);
                // PageRouting.popToPage(
                //     cont);
              }),
        ));
      },
      child: Container(
        width: 402,
        height: 70,
        color: HexColor(backgroundColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText(
              text: "Delete Account",
              color: textPrimary,
              fontWeight: FontWeight.w400,
              size: 16,
            )
          ],
        ),
      ),
    );
  }
}
