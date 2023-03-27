import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/screens/home/profile/editprofileextra/about_me.dart';
import 'package:makanaki/presentation/screens/home/profile/editprofileextra/edit_gender.dart';
import 'package:makanaki/presentation/screens/home/profile/editprofileextra/edit_studies.dart';
import 'package:makanaki/presentation/screens/home/profile/editprofileextra/profile_pic.dart';
import 'package:makanaki/presentation/screens/home/profile/editprofileextra/select_profile_settings.dart';
import 'package:makanaki/presentation/widgets/text.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: 'Profile',
          fontWeight: FontWeight.w400,
          size: 24,
          color: Colors.black,
        ),
        centerTitle: true,
        backgroundColor: HexColor(backgroundColor),
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: Container(
        height: height,
        width: width,
        color: HexColor("#F5F2F9"),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const ProfilePicture(),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: const [
                    EditAboutMe(),
                    SizedBox(
                      height: 30,
                    ),
                    EditSelectGender(),
                    SizedBox(
                      height: 30,
                    ),
                    EditStudies(),
                    SizedBox(
                      height: 30,
                    ),
                    EditProfileSetting(),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
