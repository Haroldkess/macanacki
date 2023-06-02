import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/constants/params.dart';
import 'package:makanaki/presentation/widgets/buttons.dart';
import 'package:makanaki/presentation/widgets/loader.dart';
import 'package:makanaki/services/controllers/action_controller.dart';
import 'package:provider/provider.dart';

import '../../../services/middleware/action_ware.dart';
import '../../widgets/text.dart';
import '../userprofile/user_profile_screen.dart';

class MatchRequestScreen extends StatelessWidget {
  final String userName;
  final int id;
  final String? img;
  const MatchRequestScreen(
      {super.key, required this.userName, required this.id, required this.img});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    ActionWare stream = context.watch<ActionWare>();
    ActionWare action = Provider.of<ActionWare>(context, listen: false);
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: height * 0.58, child: buildCard(img!)),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                PageRouting.pushToPage(
                                    context, UsersProfile(username: userName));
                              },
                              child: RichText(
                                  text: TextSpan(
                                      text: userName,
                                      style: GoogleFonts.spartan(
                                        color: HexColor(darkColor),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      children: [
                                    TextSpan(
                                      text: "",
                                      style: GoogleFonts.spartan(
                                          color: HexColor("#C0C0C0"),
                                          fontSize: 20),
                                    )
                                  ])),
                            ),
                          ),
                          // Image.asset(
                          //   "assets/pic/verified.png",
                          //   height: 27,
                          //   width: 27,
                          //   color: HexColor(primaryColor),
                          // )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: HexColor("#00B074"),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              AppText(
                                text: "Online Now",
                                size: 12,
                                fontWeight: FontWeight.w500,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset("assets/icon/location.svg"),
                              const SizedBox(
                                width: 5,
                              ),
                              AppText(
                                text: "2 km away",
                                size: 12,
                                fontWeight: FontWeight.w500,
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )),
              const SizedBox(
                height: 35,
              ),
              Container(
                height: 58,
                width: 280,
                child: stream.loadStatus
                    ? Loader(color: HexColor(primaryColor))
                    : AppButton(
                        width: 280,
                        height: 58,
                        color: primaryColor,
                        text: stream.followIds.contains(id)
                            ? "UnFollow"
                            : "Follow Back",
                        backColor: primaryColor,
                        onTap: () => followAction(context, userName, id),
                        curves: 37,
                        textColor: "#FFFFFF"),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 58,
                width: 280,
                child: AppButton(
                    width: 280,
                    height: 58,
                    color: "#F5F2F9",
                    text: "Maybe Later",
                    backColor: "#F5F2F9",
                    onTap: () => PageRouting.popToPage(context),
                    curves: 37,
                    textColor: "#8B8B8B"),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
          Positioned(
            top: 40,
            child: Container(
              width: width,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => PageRouting.popToPage(context),
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: HexColor("#FFFFFF"),
                            border: Border.all(
                                width: 1.0,
                                color: HexColor("#FFFFFF"),
                                style: BorderStyle.solid)),
                        child: Icon(
                          Icons.clear,
                          color: HexColor("#8B8B8B").withOpacity(.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> followAction(BuildContext context, String name, int id) async {
    ActionWare provide = Provider.of<ActionWare>(context, listen: false);

    //  provide.addFollowId(widget.data.id!);
    await ActionController.followOrUnFollowController(context, name, id);
  }

  Widget buildCard(String image) => ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  alignment: const Alignment(-0.3, 0),
                  image: NetworkImage(image),
                  fit: BoxFit.cover)),
        ),
      );
}
