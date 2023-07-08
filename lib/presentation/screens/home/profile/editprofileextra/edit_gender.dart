import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/operations.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:provider/provider.dart';

import '../../../../uiproviders/screen/gender_provider.dart';

class EditSelectGender extends StatefulWidget {
  const EditSelectGender({super.key});

  @override
  State<EditSelectGender> createState() => _EditSelectGenderState();
}

class _EditSelectGenderState extends State<EditSelectGender> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 30),
          child: Row(
            children: [
              AppText(
                text: "Gender",
                fontWeight: FontWeight.w400,
                size: 20,
                color: HexColor("#0C0C0C"),
              )
            ],
          ),
        ),
        Container(
          height: 200,
          color: HexColor(backgroundColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            children: context
                .watch<GenderProvider>()
                .genderSelect
                .map((e) => e.isSelected
                    ? ListTile(
                        onTap: () {
                          Operations.selectGenderOption(context, e.id, false);
                        },
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                border: Border.all(
                                    width: e.isSelected ? 5 : 1,
                                    color: e.isSelected
                                        ? HexColor(primaryColor)
                                        : HexColor("#C0C0C0"),
                                    style: BorderStyle.solid)),
                          ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: AppText(
                            text: e.text,
                            color: e.isSelected
                                ? HexColor("#0C0C0C")
                                : HexColor("#8B8B8B"),
                            size: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : ListTile(
                        onTap: () {
                          Operations.selectGenderOption(context, e.id, true);
                        },
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: e.isSelected ? 5 : 1,
                                    color: e.isSelected
                                        ? HexColor(primaryColor)
                                        : HexColor("#C0C0C0"),
                                    style: BorderStyle.solid)),
                          ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: AppText(
                            text: e.text,
                            color: e.isSelected
                                ? HexColor("#0C0C0C")
                                : HexColor("#8B8B8B"),
                            size: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
