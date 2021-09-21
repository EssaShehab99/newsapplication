import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:newsapplication/shared/components/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
class Setting with ChangeNotifier {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int themeModeValue=0;
  int? languageValue=0;
  String? themeModeName;
  String? languageName;
  ThemeMode themeMode = ThemeMode.system;
  bool autoDownloadMedia=false;
  String? favoriteId;
  Locale? locale=Locale('ar', 'YE');
  LocalizationsDelegate? localizationsDelegate;

  List<String> languages(){
    return [
      "english".tr().toString(),
      "arabic".tr().toString(),
    ];
  }


  Future<void> setThemeMode(int themeModeValue) async {
    final SharedPreferences prefs = await _prefs;

    await  prefs.setInt("themeModeValue", themeModeValue);
    this.themeModeValue=themeModeValue;
    getThemeMode();
  }
  Future<void> setLanguage(int languageValue,BuildContext context) async {
    final SharedPreferences prefs = await _prefs;

    await  prefs.setInt("languageValue", languageValue);
    this.languageValue=languageValue;
    getLanguage(context);
  }
  Future<void> getDownloadMedia() async {
    final SharedPreferences prefs = await _prefs;
    autoDownloadMedia = prefs.getBool('autoDownloadMediaValue') ?? false;
    notifyListeners();
  }

  Future<void> getThemeMode() async {
    final SharedPreferences prefs = await _prefs;
    themeModeValue = prefs.getInt('themeModeValue') ?? 0;
    if (themeModeValue == 1) {
      themeModeName=themeItems[1];
      themeMode = ThemeMode.light;
    } else if (themeModeValue == 2) {
      themeModeName=themeItems[2];
      themeMode = ThemeMode.dark;
    }else {
      themeModeName=themeItems[0];
      themeMode = ThemeMode.system;
    }

    notifyListeners();
  }
  Future<void> getLanguage(BuildContext context) async {
    final SharedPreferences prefs = await _prefs;
    languageValue = prefs.getInt('languageValue') ?? 0;
    if (languageValue == 0) {
      languageValue = 0;
      await EasyLocalization.of(context)?.setLocale(Locale('en','US'));
        languageName=await "english".tr().toString();

    } else {
      languageValue = 1;
     await EasyLocalization.of(context)?.setLocale(Locale('ar','YE'));
       languageName=await "arabic".tr().toString();


    }
    notifyListeners();
  }
  Future<void> setAutoDownloadMedia(bool autoDownloadMediaValue) async {
    final SharedPreferences prefs = await _prefs;

    await  prefs.setBool("autoDownloadMediaValue", autoDownloadMediaValue);

    getDownloadMedia();
  }

  Future<void> setFavoriteId(String favoriteId) async {
    final SharedPreferences prefs = await _prefs;

    await  prefs.setString("favoriteId", favoriteId);

    checkFavoriteId();
  }


  // void setLocale(Locale locale){
  //   if(!L10n.all.contains(locale)) return;
  //   _locale = locale;
  //   notifyListeners();
  // }

  void checkFavoriteId() async {
    final SharedPreferences prefs = await _prefs;
    favoriteId = prefs.getString('favoriteId');

    notifyListeners();
  }

  // Future<TextDirection> startIdentifyingPossibleLanguages(String? text)  async {
  //   // LanguageIdentifier _identifier = LanguageIdentifier();
  //   // List<IdentifiedLanguage> languages =
  //   // await _identifier.idenfityPossibleLanguages(text!) ;
  //
  //   String result = '';
  //   // for (IdentifiedLanguage l in languages) {
  //   //   result += '${l.language.toUpperCase()}';
  //   // }
  //
  //   return result.contains("AR")?TextDirection.rtl:TextDirection.ltr;
  // }
}
