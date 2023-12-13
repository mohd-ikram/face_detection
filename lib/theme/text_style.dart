import 'package:flutter/material.dart';

import '../constant/color_const.dart';

class AppTextStyle {
  //normal text styles

  static const TextStyle normalBlack8 = TextStyle(
    color: Colors.black,
    fontSize: 8,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle normalBlack10 = TextStyle(
    color: Colors.black,
    fontSize: 10,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle normalBlack12 = TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle normalBlack14 = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle normalBlack16 = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle normalWhite10 = TextStyle(
    color: Colors.white,
    fontSize: 10,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle normalWhite12 = TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle normalWhite14 = TextStyle(
    color: Colors.white,
    fontSize: 13,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle normalBlue10 = TextStyle(
    color: ColorConst.blue,
    fontSize: 10,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle normalBlue16 = TextStyle(
    color: ColorConst.blue,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  //semi bold text styles
  static const TextStyle mediumBlack14 = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle mediumBlack15 = TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle mediumBlack16 = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle mediumBlack10 = TextStyle(
    color: Colors.black,
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle mediumBlack11 = TextStyle(
    color: Colors.black,
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle mediumBlack12 = TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle mediumBlack20 = TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle mediumWhite10 = TextStyle(
    color: Colors.white,
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle mediumBlue10 = TextStyle(
    color: ColorConst.blue,
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle mediumBlue12 = TextStyle(
    color: ColorConst.blue,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle mediumBlue14 = TextStyle(
    color: ColorConst.blue,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle mediumBlue16 = TextStyle(
    color: ColorConst.blue,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  //semi bold text styles
  static const TextStyle mediumWhite14 = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle mediumWhite16 = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // bold text styles
  static const TextStyle boldBlack10 = TextStyle(
    color: Colors.black,
    fontSize: 10,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle boldBlack12 = TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle boldWhite12 = TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle boldBlack14 = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle boldBlack24 = TextStyle(
    color: Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle boldBlack16 = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle boldBlack20 = TextStyle(
    color: Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle boldWhite16 = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle boldWhite18 = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle boldWhite20 = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle boldWhite28 = TextStyle(
    color: Colors.white,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle w700LightGrey36 = TextStyle(
    color: ColorConst.lightGrey,
    fontSize: 36,
    fontWeight: FontWeight.w700,
  );


  static const TextStyle normalBlackGrey10 = TextStyle(
    color: ColorConst.blackGrey,
    fontSize: 10,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle normalBlackGrey12 = TextStyle(
    color: ColorConst.blackGrey,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle normalBlackGrey14 = TextStyle(
    color: ColorConst.blackGrey,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle boldBlackGrey18 = TextStyle(
    color: ColorConst.blackGrey,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static TextStyle themeBackgroud =
  mediumWhite16.copyWith(backgroundColor: ColorConst.primary);

  static const TextStyle normalRed12 = TextStyle(
    color: Colors.red,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle mediumRed12 = TextStyle(
    color: Colors.red,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle boldRed12 = TextStyle(
    color: Colors.red,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static TextStyle app_text_style(
      {Color color = Colors.black,
        double size = 12,
        FontWeight fontWeight = FontWeight.normal}) {
    return TextStyle(color: color, fontSize: size, fontWeight: fontWeight);
  }
}
