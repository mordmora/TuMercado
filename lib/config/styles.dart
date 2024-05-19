import 'package:flutter/material.dart';

class TextStyles {
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
}
