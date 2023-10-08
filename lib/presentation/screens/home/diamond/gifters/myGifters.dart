import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/userprofile/extras/follow_search.dart';
import 'package:macanacki/presentation/widgets/loader.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/middleware/gift_ware.dart';

import '../../../../../model/gift_diamond_history_model.dart';
import 'gifter_view.dart';

class MyGifters extends StatefulWidget {
  const MyGifters({super.key});

  @override
  State<MyGifters> createState() => _MyGiftersState();
}

class _MyGiftersState extends State<MyGifters> {
  TextEditingController searchText = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      GiftWare.instance.getReceivedDiamondsHistoryFromApi();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor("#F5F2F9"),
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size(0, 20),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, bottom: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 46,
                      //width: 383,
                      decoration: BoxDecoration(
                          color: HexColor(backgroundColor),
                          shape: BoxShape.rectangle,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0))),
                      child: TextFormField(
                        controller: searchText,
                        onChanged: (val) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: " Search",
                          hintStyle: GoogleFonts.leagueSpartan(
                              color: HexColor("#C0C0C0"), fontSize: 14),
                          border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(2.0),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                          disabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(2.0),
                              borderSide:
                                  BorderSide(color: HexColor("#F5F2F9"))),
                          focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(2.0),
                              borderSide:
                                  BorderSide(color: HexColor(primaryColor))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          title: AppText(
            text: "My Gifters",
            color: Colors.black,
            size: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.21,
          ),
          centerTitle: true,
          leading: const BackButton(color: Colors.black),
          elevation: 0,
          backgroundColor: HexColor(backgroundColor),
          toolbarHeight: 110,
        ),
        body: GiftWare.instance.loadGifters.value
            ? Center(child: Loader(color: HexColor(primaryColor)))
            : ObxValue(
                (history) => history.value.data!.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icon/diamond.svg",
                              height: 30,
                              width: 30,
                            //  color: HexColor(primaryColor),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            AppText(
                              text: "Oops you have no Gifter yet",
                              fontWeight: FontWeight.w400,
                            )
                          ],
                        ),
                      )
                    : StreamBuilder(
                        stream: null,
                        builder: (context, snapshot) {
                          List<GifterInfo> searched = history
                                  .value.data!.isEmpty
                              ? history.value.data!
                              : history.value.data!.where((element) {
                                  return element.sender!.username!
                                      .toLowerCase()
                                      .contains(searchText.text.toLowerCase());
                                }).toList();

                          return ListView.builder(
                            itemCount: searched.length,
                            itemBuilder: (context, index) {
                              GifterInfo gifter = searched[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: GifterView(
                                  data: gifter,
                                ),
                              );
                            },
                          );
                        }),
                GiftWare.instance.gifterHistory));
  }
}
