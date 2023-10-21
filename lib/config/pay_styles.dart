import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// UI Colors
const kColorBar = Colors.black;
const kColorText = Colors.white;
const kColorAccent = Color.fromRGBO(10, 115, 217, 1.0);
const kColorError = Colors.red;
const kColorSuccess = Colors.green;
const kColorNavIcon = Color.fromRGBO(131, 136, 139, 1.0);
const kColorBackground = Color.fromRGBO(30, 28, 33, 1.0);

// Weather Colors
const kWeatherReallyCold = Color.fromRGBO(3, 75, 132, 1);
const kWeatherCold = Color.fromRGBO(0, 39, 96, 1);
const kWeatherCloudy = Color.fromRGBO(51, 0, 58, 1);
const kWeatherSunny = Color.fromRGBO(212, 70, 62, 1);
const kWeatherHot = Color.fromRGBO(181, 0, 58, 1);
const kWeatherReallyHot = Color.fromRGBO(204, 0, 58, 1);

// Text Styles
const kFontSizeSuperSmall = 10.0;
const kFontSizeNormal = 16.0;
const kFontSizeMedium = 18.0;
const kFontSizeLarge = 96.0;

TextStyle kDescriptionTextStyle = GoogleFonts.leagueSpartan(
    textStyle: const TextStyle(
      color: kColorText,
      fontWeight: FontWeight.normal,
      fontSize: kFontSizeNormal,
    )
);

TextStyle kTitleTextStyle = GoogleFonts.leagueSpartan(
  textStyle: const TextStyle(
    color: kColorText,
    //fontWeight: FontWeight.bold,
    fontSize: kFontSizeNormal,
  )
);



// Inputs
const kButtonRadius = 10.0;

