import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:newsapplication/modules/post_editing/post_editing.dart';
import 'package:newsapplication/shared/components/components.dart';
import 'package:newsapplication/shared/components/constants.dart';
import '../shared/setting/setting.dart';
import 'package:provider/provider.dart';

import 'models/file_manager/files_manager.dart';
import 'models/post/favorite_posts_manager.dart';
import 'models/post/posts_manager.dart';
import 'models/title/news_titles_manager.dart';
import 'modules/about_application/about_application.dart';
import 'modules/application_setting/application_setting.dart';
import 'modules/home/home.dart';
import 'modules/news_screen/news_details.dart';
import 'modules/title_news/title_editing.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(const InitialApp());
}

class InitialApp extends StatelessWidget {
  const InitialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Setting()),
          ChangeNotifierProvider(create: (_) => NewsTitlesManager()),
          ChangeNotifierProxyProvider<NewsTitlesManager, PostsManager>(
            create: (_) => PostsManager(),
            update: (_, values, previousProvider) =>
                PostsManager()..update(values.titlesList),
          ),
          ChangeNotifierProxyProvider<PostsManager, FavoritePostManager>(
            create:(context) =>  FavoritePostManager(),
            update: (context, value, previous) => FavoritePostManager()..update(value.postsList),
          ),
          ChangeNotifierProvider(create: (_) => FilesManager()),
        ],
        child: const LauncherApp(),
      ),
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ar', 'YE'),
      ],
      path: 'assets/translation',
      saveLocale: true,
    );
  }
}

class LauncherApp extends StatelessWidget {
  const LauncherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      themeMode: Provider.of<Setting>(context, listen: true).themeMode,
      theme: ThemeData(
          fontFamily: "Cairo",
          primaryColor: primaryColor_light,
          backgroundColor: backgroundColor_light,
          dividerColor: reverseColor_light,
          indicatorColor: backgroundColor_light,
          cardColor: reverseColor_light,
          colorScheme: ColorScheme.light(),
          iconTheme: IconThemeData(color: reverseColor_light),
          popupMenuTheme: PopupMenuThemeData(
            color: backgroundColor_light,
          ),
          inputDecorationTheme: InputDecorationTheme(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: secondaryColor_light))),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(primaryColor_light),
                overlayColor: MaterialStateProperty.all(backgroundColor_light)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius))),
                backgroundColor:
                    MaterialStateProperty.all(backgroundColor_light)),
          ),
          tabBarTheme: TabBarTheme(
            labelColor: reverseColor_light,
            unselectedLabelColor: secondaryColor_light,
            labelStyle: textStyle(fontSize: 15, color: reverseColor_light),
            unselectedLabelStyle:
                textStyle(fontSize: 13, color: secondaryColor_light),
          ),
          appBarTheme: AppBarTheme(
            color: backgroundColor_light,
            titleTextStyle: textStyle(color: reverseColor_light, fontSize: 16),
            iconTheme: IconThemeData(color: reverseColor_light),
          ),
          checkboxTheme: CheckboxThemeData(
            checkColor: MaterialStateProperty.all(primaryColor_light),
            fillColor: MaterialStateProperty.all(reverseColor_light),
          ),
          radioTheme: RadioThemeData(
            fillColor: MaterialStateProperty.all(reverseColor_light),
          ),
          textTheme: TextTheme(
              headline1: textStyle(fontSize: 16, color: reverseColor_light),
              headline2: textStyle(fontSize: 15, color: reverseColor_light),
              headline3: textStyle(fontSize: 14, color: reverseColor_light),
              headline4: textStyle(fontSize: 13, color: reverseColor_light),
              headline5: textStyle(
                  fontSize: 12,
                  color: reverseColor_light,
                  fontWeight: FontWeight.normal),
              headline6: textStyle(fontSize: 11, color: reverseColor_light),
              bodyText1: textStyle(fontSize: 15, color: backgroundColor_light),
              bodyText2: textStyle(fontSize: 14, color: backgroundColor_light),
              subtitle1: textStyle(
                  fontSize: 13,
                  color: secondaryColor_light,
                  fontWeight: FontWeight.normal),
              button: textStyle(
                  fontSize: 13,
                  color: primaryColor_light,
                  fontWeight: FontWeight.bold),
              caption: textStyle(
                  fontSize: 14,
                  color: reverseColor_light,
                  fontWeight: FontWeight.normal),
              overline: textStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          textSelectionTheme: TextSelectionThemeData(
              selectionHandleColor: reverseColor_light,
              cursorColor: reverseColor_light)),
      darkTheme: ThemeData(
          fontFamily: "Cairo",
          primaryColor: primaryColor_dark,
          backgroundColor: backgroundColor_dark,
          dividerColor: reverseColor_dark,
          indicatorColor: backgroundColor_dark,
          cardColor: reverseColor_dark,
          colorScheme: ColorScheme.dark(),
          iconTheme: IconThemeData(color: reverseColor_dark),
          popupMenuTheme: PopupMenuThemeData(
            color: backgroundColor_dark,
          ),
          inputDecorationTheme: InputDecorationTheme(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: secondaryColor_dark))),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0))),
                backgroundColor: MaterialStateProperty.all(primaryColor_dark),
                overlayColor: MaterialStateProperty.all(backgroundColor_dark)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius))),
                backgroundColor:
                    MaterialStateProperty.all(backgroundColor_dark)),
          ),
          tabBarTheme: TabBarTheme(
            labelColor: reverseColor_dark,
            unselectedLabelColor: secondaryColor_dark,
            labelStyle: textStyle(fontSize: 15, color: reverseColor_dark),
            unselectedLabelStyle:
                textStyle(fontSize: 13, color: secondaryColor_dark),
          ),
          appBarTheme: AppBarTheme(
            color: backgroundColor_dark,
            titleTextStyle: textStyle(color: reverseColor_dark, fontSize: 16),
            iconTheme: IconThemeData(color: reverseColor_dark),
          ),
          checkboxTheme: CheckboxThemeData(
            checkColor: MaterialStateProperty.all(primaryColor_dark),
            fillColor: MaterialStateProperty.all(reverseColor_dark),
          ),
          radioTheme: RadioThemeData(
            fillColor: MaterialStateProperty.all(reverseColor_dark),
          ),
          textTheme: TextTheme(
              headline1: textStyle(fontSize: 16, color: reverseColor_dark),
              headline2: textStyle(fontSize: 15, color: reverseColor_dark),
              headline3: textStyle(fontSize: 14, color: reverseColor_dark),
              headline4: textStyle(fontSize: 13, color: reverseColor_dark),
              headline5: textStyle(
                  fontSize: 12,
                  color: reverseColor_dark,
                  fontWeight: FontWeight.normal),
              headline6: textStyle(fontSize: 11, color: reverseColor_dark),
              bodyText1: textStyle(fontSize: 15, color: backgroundColor_dark),
              bodyText2: textStyle(fontSize: 14, color: backgroundColor_dark),
              subtitle1: textStyle(
                  fontSize: 13,
                  color: secondaryColor_dark,
                  fontWeight: FontWeight.normal),
              button: textStyle(
                  fontSize: 13,
                  color: primaryColor_dark,
                  fontWeight: FontWeight.bold),
              caption: textStyle(
                  fontSize: 14,
                  color: reverseColor_dark,
                  fontWeight: FontWeight.normal),
              overline: textStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          textSelectionTheme: TextSelectionThemeData(
              selectionHandleColor: reverseColor_dark,
              cursorColor: reverseColor_dark)),
      initialRoute: '/',
      routes: {
        '/': (ctx) => Home(),
        PostEditing.postEditing: (ctx) => const PostEditing(),
        NewsDetails.newsDetailsScreen: (ctx) => const NewsDetails(),
        TitleEditing.titleEditing: (ctx) => const TitleEditing(),
        AboutApplication.aboutApplication: (ctx) => const AboutApplication(),
        ApplicationSetting.applicationSetting: (ctx) =>
            const ApplicationSetting(),
        /*   AddTitleBar.addTitleBar: (ctx) => const AddTitleBar(),
*/
      },
    );
  }
}
