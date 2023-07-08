import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/widgets/text.dart';

class EditProfileSetting extends StatefulWidget {
  const EditProfileSetting({super.key});

  @override
  State<EditProfileSetting> createState() => _EditProfileSettingState();
}

class _EditProfileSettingState extends State<EditProfileSetting> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 30),
          child: Row(
            children: [
              AppText(
                text: "Profile Settings",
                fontWeight: FontWeight.w400,
                size: 20,
                color: HexColor("#0C0C0C"),
              )
            ],
          ),
        ),
        Container(
          height: 150,
          color: HexColor(backgroundColor),
          child: Column(
            children: [
              SwitchListTile(
                value: true,
                activeColor: HexColor(primaryColor),
                onChanged: (val) {},
                title: AppText(text: "Don’t show my age"),
              ),
              SwitchListTile(
                value: false,
                onChanged: (val) {},
                title: AppText(text: "Don’t show my Distance"),
              ),
            ],
          ),
        )
      ],
    );
  }
}
