import 'dart:developer';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/model/gender_model.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/constants/params.dart';
import 'package:macanacki/presentation/model/ui_model.dart';
import 'package:macanacki/presentation/operations.dart';
import 'package:macanacki/presentation/screens/kyc/kyc_notification.dart';
import 'package:macanacki/presentation/screens/onboarding/user_name.dart';
import 'package:macanacki/presentation/widgets/buttons.dart';
import 'package:macanacki/presentation/widgets/loader.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/controllers/category_controller.dart';
import 'package:macanacki/services/controllers/gender_controller.dart';
import 'package:macanacki/services/middleware/category_ware.dart';
import 'package:macanacki/services/middleware/gender_ware.dart';
import 'package:macanacki/services/temps/temp.dart';
import 'package:provider/provider.dart';

import '../../../model/category_model.dart';
import '../../uiproviders/screen/gender_provider.dart';
import '../../widgets/form.dart';
import '../../widgets/text.dart';
import 'business/business_info.dart';
import 'dob_screen.dart';

class SelectCategory extends StatefulWidget {
  final GenderList? data;
  const SelectCategory({super.key, this.data});

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  TextEditingController catEc = TextEditingController();
  final GlobalKey<FormFieldState> FormKey = GlobalKey();
  int id = 0;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    CategoryWare stream = context.watch<CategoryWare>();

    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding - 20),
        child: ListView(
          children: [
            SizedBox(
              height: height * 0.25,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: width / 1.2,
                        child: AppText(
                          text: "Select business category",
                          align: TextAlign.center,
                          size: 30,
                          fontWeight: FontWeight.w700,
                        )),
                  ],
                ),
              ),
            ),
            stream.loadStatus
                ? Loader(color: HexColor(primaryColor))
                : Column(
                    children: [
                      forms(context, "Search category", const SizedBox.shrink(),
                          catEc, TextInputType.streetAddress, FormKey),
                      stream.category.isEmpty
                          ? const SizedBox.shrink()
                          : Column(
                              children: [
                                SizedBox(
                                  height: 7,
                                ),
                                SizedBox(
                                  height: 300,
                                  child: stream.loadStatus
                                      ? Loader(color: HexColor(primaryColor))
                                      : StreamBuilder(
                                          stream: null,
                                          builder: (context, snapshot) {
                                            List<Datum> catList = stream
                                                .category
                                                .where((element) {
                                              return element.name!
                                                  .toLowerCase()
                                                  .contains(
                                                      catEc.text.toLowerCase());
                                            }).toList();
                                            return listOfSuggestions(
                                                catList.isEmpty ? [] : catList);
                                          }),
                                ),
                              ],
                            )
                    ],
                  ),
            SizedBox(
              height: 50,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: AppButton(
                      width: 0.8,
                      height: 0.06,
                      color: primaryColor,
                      text: "Continue",
                      backColor: primaryColor,
                      curves: buttonCurves * 5,
                      textColor: backgroundColor,
                      onTap: () async {
                        _submit(context);
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget forms(
      BuildContext context,
      String hint,
      Widget suffix,
      TextEditingController controller,
      TextInputType type,
      GlobalKey<FormFieldState>? key,
      [Widget? prefix,
      int? input]) {
    return AppForm(
      hint: hint,
      borderRad: 0,
      backColor: HexColor(backgroundColor),
      height: 56,
      fontSize: 13,
      hintColor: Colors.black45,
      suffix: suffix,
      prefix: prefix,
      textInputType: type,
      controller: controller,
      input: input,
      formFieldKey: key,
    );
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      CategoryController.retrievCategoryController(context);
    });
  }

  ScrollController scroller = ScrollController();

  Widget listOfSuggestions(List<Datum> cat) {
    return Scrollbar(
      controller: scroller,
      interactive: true,
      thumbVisibility: true,
      child: ListView(
        controller: scroller,
        physics: BouncingScrollPhysics(),
        children: [
          ...cat
              .map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: InkWell(
                        onTap: () async {
                          CategoryWare stream =
                              Provider.of<CategoryWare>(context, listen: false);

                          setState(() {
                            catEc = TextEditingController(text: e.name);
                          });
                          stream.selectCat(e);
                        },
                        child: Container(
                          height: 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: AppText(
                                      text: e.name!,
                                      size: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )),
                  ))
              .toList()
        ],
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    Temp temp = Provider.of<Temp>(context, listen: false);
    CategoryWare stream = Provider.of<CategoryWare>(context, listen: false);

    if (catEc.text.isEmpty || stream.selected.id == null) {
      showToast2(context, "Select a category to proceed");
      return;
    } else {
      temp
          .addCategoryTemp(id, catEc.text)
          .whenComplete(() => PageRouting.pushToPage(
              context,
              SelectUserName(
                genderId: widget.data!.id!,
              )));
    }
  }
}
