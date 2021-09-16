import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ApplicationSetting with ChangeNotifier {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int? themeModeValue;
  int? languageValue;
  String? themeModeName="";
  String? languageName="Ara";
  ThemeMode themeMode = ThemeMode.system;
  bool? isImageLoad;
  String? favoriteId;
  Locale? _locale;
  Locale? get locale => _locale;

  Future<void> setThemeModeValue(int themeModeValue) async {
    final SharedPreferences prefs = await _prefs;

    await  prefs.setInt("themeModeValue", themeModeValue);

    checkThemeMode();
  }
  Future<void> setFavoriteId(String favoriteId) async {
    final SharedPreferences prefs = await _prefs;

    await  prefs.setString("favoriteId", favoriteId);

    checkFavoriteId();
  }

  Future<void> setImageLoadValue(bool isImageLoadValue) async {
    final SharedPreferences prefs = await _prefs;

    await  prefs.setBool("isImageLoadValue", isImageLoadValue);

    checkImageLoad();
  }
  // void setLocale(Locale locale){
  //   if(!L10n.all.contains(locale)) return;
  //   _locale = locale;
  //   notifyListeners();
  // }
  void checkThemeMode() async {
    final SharedPreferences prefs = await _prefs;
    themeModeValue = prefs.getInt('themeModeValue') ?? 0;
    if (themeModeValue == 0) {
      // themeModeName=StyleAndText.arabicLanguageItemDialogRadioListTile[0];
      themeMode = ThemeMode.system;
    } else if (themeModeValue == 1) {
      // themeModeName=StyleAndText.arabicLanguageItemDialogRadioListTile[1];
      themeMode = ThemeMode.light;
    } else if (themeModeValue == 2) {
      // themeModeName=StyleAndText.arabicLanguageItemDialogRadioListTile[2];
      themeMode = ThemeMode.dark;
    }

    notifyListeners();
  }
  void checkLanguage() async {
    final SharedPreferences prefs = await _prefs;
    languageValue = prefs.getInt('languageValue') ?? 0;
    if (languageValue == 0) {
      // languageName=StyleAndText.language[0];
      languageValue = 0;
    } else if (languageValue == 1) {
      // themeModeName=StyleAndText.arabicLanguageItemDialogRadioListTile[1];
      languageValue = 1;
    }

    notifyListeners();
  }
  void checkImageLoad() async {
    final SharedPreferences prefs = await _prefs;
    isImageLoad = prefs.getBool('isImageLoadValue') ?? true;

    notifyListeners();
  }
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
