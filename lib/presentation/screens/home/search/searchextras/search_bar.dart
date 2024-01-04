import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/services/controllers/search_controller.dart';
import '../../../../constants/colors.dart';
import '../../../../operations.dart';

class GlobalSearchBar extends StatelessWidget {
  TextEditingController x;

  GlobalSearchBar({
    super.key,
    required this.x,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      //width: 383,
      decoration: BoxDecoration(
          color: HexColor(backgroundColor),
          shape: BoxShape.rectangle,
          border: Border.all(color: backgroundSecondary),
          borderRadius: const BorderRadius.all(Radius.circular(8.0))),
      child: TextFormField(
        controller: x,
        cursorColor: backgroundSecondary,
        enableSuggestions: false,
        autocorrect: false,
        autofocus: true,
        style: GoogleFonts.roboto(
          color: textPrimary,
        ),
        onChanged: (value) async {
          // if (value.isEmpty) {
          //   return;
          // }
          // SearchAppController.retrievSearchUserController(context, value);

          await Future.delayed(const Duration(milliseconds: 1000)).whenComplete(
              () => SearchAppController.retrievSearchUserController(
                  context, value));
        },
        onFieldSubmitted: (val) {
          if (val.isNotEmpty) {
            SearchAppController.retrievSearchUserController(context, val);
          }

          emitter("submitted");
        },
        decoration: InputDecoration(
          hintText: " Search",
          hintStyle: GoogleFonts.roboto(color: textPrimary, fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          enabledBorder: InputBorder.none,
          disabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(2.0),
              borderSide: BorderSide(color: HexColor("#F5F2F9"))),
          focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(2.0),
              borderSide: BorderSide(color: Colors.transparent)),
        ),
      ),
    );
  }
}

class GlobalSearchBarHolder extends StatelessWidget {
  GlobalSearchBarHolder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      //width: 383,`
      decoration: BoxDecoration(
          color: HexColor(backgroundColor),
          shape: BoxShape.rectangle,
          border: Border.all(color: backgroundSecondary),
          borderRadius: const BorderRadius.all(Radius.circular(8.0))),
      child: TextFormField(
        //   controller: x,
        cursorColor: HexColor(primaryColor),
        enableSuggestions: false,
        autocorrect: false,
        enabled: false,
        onChanged: (value) async {
          // if (value.isEmpty) {
          //   return;
          // }
          SearchAppController.retrievSearchUserController(context, value);

          // await Future.delayed(const Duration(milliseconds: 1000)).whenComplete(
          //     () =>
          //         SearchController.retrievSearchUserController(context, value));
        },
        onFieldSubmitted: (val) {
          if (val.isNotEmpty) {
            SearchAppController.retrievSearchUserController(context, val);
          }
          emitter("submitted");
        },
        decoration: InputDecoration(
          hintText: "   Search",
          hintStyle: GoogleFonts.roboto(color: textPrimary, fontSize: 14),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(2.0),
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(2.0),
              borderSide: BorderSide(color: HexColor(primaryColor))),
        ),
      ),
    );
  }
}
