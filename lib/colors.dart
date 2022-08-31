import 'dart:ui';

class MyColors {
  static const textBlueColor = Color.fromRGBO(78, 122, 199, 1);
  static const backgroundColor = Color.fromRGBO(234, 240, 254, 1);
}

Color HexaColor(String strcolor, {int opacity = 15}) {
  //opacity is optional value
  strcolor = strcolor.replaceAll("#", ""); //replace "#" with empty value
  String stropacity =
      opacity.toRadixString(16); //convert integer opacity to Hex String
  return Color(int.parse("$stropacity$stropacity" + strcolor, radix: 16));
  //here color format is 0xFFDDDDDD, where FF is opacity, and DDDDDD is Hex Color
}
