import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle getTittleStyleWithSize(double fontSize) {
    return TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        fontFamily: 'Outfit',
        letterSpacing: BorderSide.strokeAlignInside);
  }

  static const TextStyle title = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w500,
      fontFamily: 'Outfit',
      letterSpacing: BorderSide.strokeAlignInside);

  static const TextStyle subtitle = TextStyle(
    fontSize: 18,
    fontFamily: 'Outfit',
    letterSpacing: BorderSide.strokeAlignInside,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle normal = TextStyle(
    fontSize: 16,
    fontFamily: 'Outfit',
    letterSpacing: .2,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle error = TextStyle(
    fontSize: 16,
    fontFamily: 'Outfit',
    letterSpacing: .2,
    fontWeight: FontWeight.w400,
    color: Colors.red,
  );

  static const TextStyle productTitle = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontFamily: 'Outfit',
    letterSpacing: .2,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle productPrice = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontFamily: 'Outfit',
    letterSpacing: .2,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle profileText = TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontFamily: 'Outfit',
      letterSpacing: .2,
      fontWeight: FontWeight.w400);

  static const TextStyle profileName = TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontFamily: 'Outfit',
      letterSpacing: .2,
      fontWeight: FontWeight.w500);

  static const TextStyle hintStyle = TextStyle(
      fontSize: 16,
      fontFamily: 'Outfit',
      letterSpacing: .2,
      fontWeight: FontWeight.w400,
      color: Colors.grey);
}
