import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/home/search/searchextras/search_bar.dart';
import 'package:macanacki/presentation/screens/home/search/searchextras/user_search_result.dart';
import 'package:macanacki/presentation/screens/userprofile/extras/follow_search.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../services/controllers/mode_controller.dart';
import '../../../operations.dart';

class GlobalSearch extends StatefulWidget {
  const GlobalSearch({
    super.key,
  });

  @override
  State<GlobalSearch> createState() => _GlobalSearchState();
}

class _GlobalSearchState extends State<GlobalSearch> {
  TextEditingController controller = TextEditingController();
  SharedPreferences? pref;
  String? userName = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: HexColor("#F5F2F9"),
        backgroundColor: backgroundSecondary,

        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,

          bottom: PreferredSize(
            preferredSize: Size(0, 20),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 0.0, bottom: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () => PageRouting.popToPage(context),
                            icon: Icon(
                              Icons.arrow_back,
                              color: textWhite,
                            )),
                        Expanded(
                          child: GlobalSearchBar(
                            x: controller,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // title: Padding(
          //   padding: const EdgeInsets.only(top: 20),
          //   child: AppText(
          //     text: "Global Search",
          //     color: Colors.black,
          //     size: 20,
          //     fontWeight: FontWeight.w800,
          //   ),
          // ),
          // centerTitle: true,
          // leading: const BackButton(color: Colors.black),
          elevation: 0,
          backgroundColor: HexColor(backgroundColor),
          toolbarHeight: 60,
          //  leading: BackButton(color: ),
        ),
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (_) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SizedBox(
              height: Get.height,
              width: Get.width,
              child: UserGlobalResult(
                userName: userName!,
              ),
            )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initPref();
    // SchedulerBinding.instance.addPostFrameCallback((_) async {
    //   await ModeController.handleMode("online");
    // });
    // Operations.controlSystemColor();
  }

  initPref() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      userName = pref!.getString(userNameKey);
    });
  }
}
