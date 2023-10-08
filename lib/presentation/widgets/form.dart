import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';

class AppForm extends StatefulWidget {
  Color? hintColor;
  String? hint;
  Widget? suffix;
  Color? backColor;
  double? borderRad;
  double? height;
  double? fontSize;
  Widget? prefix;
  bool? enable;
  TextEditingController? controller;
  TextInputType? textInputType;
  int? input;
  final GlobalKey<FormFieldState>? formFieldKey;

  AppForm(
      {super.key,
      this.hint,
      this.hintColor,
      this.suffix,
      this.prefix,
      this.backColor,
      this.borderRad,
      this.height,
      this.fontSize,
      this.controller,
      this.input,
      this.textInputType,
      this.enable,
      this.formFieldKey});

  @override
  State<AppForm> createState() => _AppFormState();
}

class _AppFormState extends State<AppForm> {
  bool validated = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: validated ? 60 : widget.height,
      //width: 383,
      decoration: BoxDecoration(
          color: widget.backColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRad!)),
          border: widget.enable == null || widget.enable!
              ? null
              : Border.all(
                  style: BorderStyle.solid, color: HexColor("#242830"))),
      child: Center(
        child: TextFormField(
            key: widget.formFieldKey == null ? null : widget.formFieldKey!,
            controller: widget.controller,
            keyboardType: widget.textInputType,
            //scrollPadding: EdgeInsets.only(left: 10, right: 10),
            maxLength: widget.input,
            enabled: widget.enable ?? true,
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     setState(() {
            //       validated = true;
            //     });
            //     return "This field is required";
            //   } else {
            //     setState(() {
            //       validated = false;
            //     });
            //   }
            //   return null;
            // },
            onChanged: (val) {
              // if (widget.hint == "Enter pickup address") {
              //   PlacesController.getPlaces(context, val);
              // }
            },
            style: GoogleFonts.overpass(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              counterStyle: TextStyle(),
              contentPadding: widget.input != null
                  ? EdgeInsets.only(top: 20, left: 10, right: 10)
                  : EdgeInsets.only(top: 18, left: 10, right: 10),
              hintText: " ${widget.hint}",
              hintStyle: GoogleFonts.overpass(
                  color: widget.hintColor, fontSize: widget.fontSize),
              suffixIcon: widget.suffix,
              prefixIcon: widget.prefix,
              errorMaxLines: 1,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 2.0),
                borderRadius: BorderRadius.zero,
              ),
              border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: const BorderSide(color: Colors.transparent)),
              // focusedBorder: const UnderlineInputBorder(
              //     borderSide: BorderSide(color: Colors.transparent)),
            )),
      ),
    );
  }
}

class AppFormAmount extends StatefulWidget {
  Color? hintColor;
  String? hint;
  Widget? suffix;
  Color? backColor;
  double? borderRad;
  double? height;
  double? fontSize;
  Widget? prefix;
  bool? enable;
  TextEditingController? controller;
  TextInputType? textInputType;
  int? input;
  final GlobalKey<FormFieldState>? formFieldKey;
  int max;
  int min;

  AppFormAmount(
      {super.key,
      this.hint,
      this.hintColor,
      this.suffix,
      this.prefix,
      this.backColor,
      this.borderRad,
      required this.max,
       required this.min,
      this.height,
      this.fontSize,
      this.controller,
      this.input,
      this.textInputType,
      this.enable,
      this.formFieldKey});

  @override
  State<AppFormAmount> createState() => _AppFormAmountState();
}

class _AppFormAmountState extends State<AppFormAmount> {
  bool validated = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: validated ? 60 : widget.height,
      //width: 383,
      decoration: BoxDecoration(
          color: widget.backColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRad!)),
          border: widget.enable == null || widget.enable!
              ? null
              : Border.all(
                  style: BorderStyle.solid, color: HexColor("#242830"))),
      child: Center(
        child: TextFormField(
            key: widget.formFieldKey == null ? null : widget.formFieldKey!,
            controller: widget.controller,
            keyboardType: const TextInputType.numberWithOptions(),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],

            //scrollPadding: EdgeInsets.only(left: 10, right: 10),
            maxLength: widget.input,
            enabled: widget.enable ?? true,
            maxLines: 1,

            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     setState(() {
            //       validated = true;
            //     });
            //     return "This field is required";
            //   } else {
            //     setState(() {
            //       validated = false;
            //     });
            //   }
            //   return null;
            // },
            onChanged: (value) {
              final number = int.tryParse(value);
              if (number != null) {
                final text = number.clamp(widget.min, widget.max).toString();
                final selection = TextSelection.collapsed(
                  offset: text.length,
                );
                widget.controller!.value = TextEditingValue(
                  text: text,
                  selection: selection,
                );
              }

              // if (widget.hint == "Enter pickup address") {
              //   PlacesController.getPlaces(context, val);
              // }
            },
            style: GoogleFonts.overpass(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              counterStyle: TextStyle(),
              contentPadding: widget.input != null
                  ? EdgeInsets.only(top: 20, left: 10, right: 10)
                  : EdgeInsets.only(top: 18, left: 10, right: 10),
              hintText: " ${widget.hint}",
              hintStyle: GoogleFonts.overpass(
                  color: widget.hintColor, fontSize: widget.fontSize),
              suffixIcon: widget.suffix,
              prefixIcon: widget.prefix,
              errorMaxLines: 1,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 2.0),
                borderRadius: BorderRadius.zero,
              ),
              border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: const BorderSide(color: Colors.transparent)),
              // focusedBorder: const UnderlineInputBorder(
              //     borderSide: BorderSide(color: Colors.transparent)),
            )),
      ),
    );
  }
}
