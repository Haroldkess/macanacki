import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/controllers/create_post_controller.dart';
import 'package:macanacki/services/middleware/action_ware.dart';
import 'package:macanacki/services/middleware/button_ware.dart';
import 'package:macanacki/services/middleware/create_post_ware.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

import '../../../../../model/button_model.dart';
import '../../../../allNavigation.dart';
import '../../../../constants/colors.dart';
import '../../../../widgets/text.dart';

buttonIndividualModal(
    BuildContext context, TextEditingController buttonController) async {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        // ButtonWare button = context.watch<ButtonWare>();
        ButtonWare stream = context.watch<ButtonWare>();

        return Padding(
          padding: EdgeInsets.only(
              top: 8.0,
              left: 8.0,
              right: 8.0,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () => PageRouting.popToPage(context),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ...Provider.of<ButtonWare>(context, listen: false).buttons.map(
                      (e) => ExpansionTileCard(
                        key: e.key,
                        title: AppText(
                          text: e.name!,
                          fontWeight: FontWeight.bold,
                          size: 15,
                        ),
                        expandedTextColor: HexColor(primaryColor),
                        trailing: Icon(Icons.send),
                        children: <Widget>[
                          const Divider(
                            thickness: 1.0,
                            height: 1.0,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: IndividualButtonForm(
                                controller: buttonController,
                                name: e.name!,
                                id: e.id!,
                                thisKey: e.key,
                                append: e.apendLink!,
                              )),
                        ],
                      ),
                    )
              ],
            ),
          ),
        );
      });
}

class IndividualButtonForm extends StatefulWidget {
  TextEditingController controller;
  String name;
  int id;
  String append;
  GlobalKey<ExpansionTileCardState>? thisKey;

  IndividualButtonForm(
      {super.key,
      required this.controller,
      required this.name,
      required this.id,
      required this.append,
      required this.thisKey});

  @override
  State<IndividualButtonForm> createState() => _IndividualButtonFormState();
}

class _IndividualButtonFormState extends State<IndividualButtonForm> {
  String error = "";
  String code = "";
  @override
  Widget build(BuildContext context) {
    ButtonWare button = Provider.of<ButtonWare>(context, listen: false);
    ButtonWare stream = context.watch<ButtonWare>();

    // button.addIndex(0);
    // button.addUrl('');

    return Row(
      children: [
        widget.name == "Call Now" || widget.name == "Whatsapp"
            ? CountryCodePicker(
                onInit: (value) {
                  ButtonWare button1 =
                      Provider.of<ButtonWare>(context, listen: false);
                  print("${value!.dialCode} this the the code");
                  button1.addCode(value.dialCode!);
                },
                onChanged: (value) {
                  ButtonWare button1 =
                      Provider.of<ButtonWare>(context, listen: false);
                  print("${value.dialCode} this the the code");
                  button1.addCode(value.dialCode!);
                },
                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                initialSelection: 'NG',
                favorite: ['+234', 'NG'],
                // optional. Shows only country name and flag
                showCountryOnly: false,
                // optional. Shows only country name and flag when popup is closed.
                showOnlyCountryWhenClosed: false,
                // optional. aligns the flag and the Text left
                alignLeft: false,
              )
            : const SizedBox.shrink(),
        Expanded(
          child: TextFormField(
            initialValue: stream.index == widget.id && stream.url.isNotEmpty
                ? widget.name == "Call Now"
                    ? stream.url.split('4')[1]
                    : stream.url
                : null,
            keyboardType: widget.name == "Call Now" || widget.name == "Whatsapp"
                ? TextInputType.phone
                : TextInputType.url,

            enabled: (stream.index == 0 && stream.url.isEmpty) ||
                    stream.index == widget.id && stream.url.isNotEmpty
                ? true
                : false,

            onTap: () {
              // if (button.index != id) {
              //   showToast2(context, "You can only add 1 button");
              // }
              // thisKey!.currentState?.collapse();
            },
            //   validator: (value)=>RegExp(r"^(https?:\/\/(.+?\.)?\.com(\/[A-Za-z0-9\-\._~:\/\?#\[\]@!$&'\(\)\*\+,;\=]*)?)").hasMatch(value!)?null:'Not a valid google drive url',

            cursorColor: HexColor(primaryColor),
            style: GoogleFonts.leagueSpartan(
              color: HexColor(darkColor),
              fontSize: 14,
            ),
            maxLength: widget.name == "Call Now" ? 10 : null,
            onChanged: (value) async {
              ButtonWare button1 =
                  Provider.of<ButtonWare>(context, listen: false);
              if (value.isEmpty) {
                button.addIndex(0);
                button.addUrl('');
                button.addName("");
              } else {
                if (widget.name == "Whatsapp") {
                  button.addUrl(widget.append + button1.code + value);
                  button.addIndex(widget.id);
                  button.addName(widget.name);
                } else if (widget.name == "Call Now") {
                  button.addUrl(button.code + value);
                  button.addIndex(widget.id);
                  button.addName(widget.name);
                } else {
                  button.addUrl(value);
                  button.addIndex(widget.id);
                  button.addName(widget.name);
                }
              }

              // RegisterUsernameController.usernameController(
              //     context, userName.text);
            },
            //maxLength:  ,
            validator: ((value) {
              if ((value!.contains("https://") || value.contains(".com")) &&
                  (widget.name != "Call Now" || widget.name != "Whatsapp")) {
                setState(() {
                  error = "";
                });
                return null;
              } else {
                setState(() {
                  error = "invalid url";
                });
                return "invalid url";
              }
            }),

            decoration: InputDecoration(
              // suffixIcon: Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     // stream.verifyName
              //     //     ? SvgPicture.asset("assets/icon/tickgood.svg")
              //     //     : SvgPicture.asset("assets/icon/tickbad.svg")
              //   ],
              // ),
              contentPadding: EdgeInsets.only(
                  left: 20,
                  top: widget.name == "Call Now" || widget.name == "Whatsapp"
                      ? 20
                      : 17),
              hintText: widget.name == "Call Now" || widget.name == "Whatsapp"
                  ? "Phone"
                  : "Url",
              errorText: error,
              errorStyle: TextStyle(color: Colors.red),
              hintStyle:
                  GoogleFonts.leagueSpartan(color: HexColor('#C0C0C0'), fontSize: 12),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
