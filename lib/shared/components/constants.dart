import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
enum TypeTitle {
  FAVORITE,
  MIXED,
  CLOUD,
}
List<String> itemsPopupMenuButton = [
  "setting".tr().toString(),
  "about".tr().toString(),
  "addTitle".tr().toString(),
  "exit".tr().toString(),
];

String timeFormat = 'dd/MM/yyyy hh:mm a';

Color primaryColor_light=Color.fromRGBO(255, 255, 255, 1);
Color secondaryColor_light=Color.fromRGBO(170, 170, 170, 1);
Color reverseColor_light=Color.fromRGBO(0, 0, 0, 1);