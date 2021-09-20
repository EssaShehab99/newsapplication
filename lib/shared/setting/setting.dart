import 'package:flutter/material.dart';
import 'package:newsapplication/shared/components/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Setting with ChangeNotifier {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int themeModeValue=0;
  int? languageValue=0;
  String? themeModeName="";
  String? languageName="Arabic";
  ThemeMode themeMode = ThemeMode.system;
  bool autoDownloadMedia=false;
  String? favoriteId;
  Locale? _locale;
  Locale? get locale => _locale;

  Future<void> setThemeMode(int themeModeValue) async {
    final SharedPreferences prefs = await _prefs;

    await  prefs.setInt("themeModeValue", themeModeValue);
    this.themeModeValue=themeModeValue;
    getThemeMode();
  }
  Future<void> setLanguage(int languageValue) async {
    final SharedPreferences prefs = await _prefs;

    await  prefs.setInt("languageValue", languageValue);
    this.languageValue=languageValue;
    getLanguage();
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
  Future<void> getLanguage() async {
    final SharedPreferences prefs = await _prefs;
    languageValue = prefs.getInt('languageValue') ?? 0;
    if (languageValue == 0) {
      languageName=languages[0];
      languageValue = 0;
    } else {
      languageName=languages[1];
      languageValue = 1;
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
