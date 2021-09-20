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
          ChangeNotifierProvider(create: (_) => PostsManager()),
          ChangeNotifierProvider(create: (_) => Setting()),
          ChangeNotifierProvider(create: (_) => NewsTitlesManager()),
          ChangeNotifierProvider(create: (_) => FavoritePostManager()),
          ChangeNotifierProvider(create: (_) => FilesManager()),
        ],
        child: const LauncherApp(),
      ),
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ar', 'YE'),
      ],
      path: 'assets/translation',
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
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
          fontFamily: "Cairo",
          primaryColor: primaryColor_light,
          backgroundColor: backgroundColor_light,
          indicatorColor: backgroundColor_light,
          tabBarTheme: TabBarTheme(
            labelColor: reverseColor_light,
            unselectedLabelColor: secondaryColor_light,
            labelStyle: textStyle(fontSize: 15, color: reverseColor_light),
            unselectedLabelStyle:
                textStyle(fontSize: 13, color: secondaryColor_light),
          ),
          appBarTheme: AppBarTheme(
            color: primaryColor_light,
            titleTextStyle: textStyle(color: reverseColor_light,fontSize: 16),
            iconTheme: IconThemeData(color: reverseColor_light),
          ),
          checkboxTheme: CheckboxThemeData(
            checkColor: MaterialStateProperty.all(primaryColor_light),
            fillColor: MaterialStateProperty.all(secondaryColor_light),
          ),
          textTheme: TextTheme(
            headline1: textStyle(fontSize: 16, color: reverseColor_light),
            headline2: textStyle(fontSize: 15, color: reverseColor_light),
            headline3: textStyle(fontSize: 14, color: reverseColor_light),
            headline4: textStyle(fontSize: 13, color: reverseColor_light),
            headline5: textStyle(fontSize: 12, color: reverseColor_light, fontWeight: FontWeight.normal),
            headline6: textStyle(fontSize: 11, color: reverseColor_light),
            bodyText1: textStyle(fontSize: 15, color: backgroundColor_light),
            bodyText2: textStyle(fontSize: 14, color: backgroundColor_light),
            subtitle1: textStyle(fontSize: 13, color: secondaryColor_light, fontWeight: FontWeight.normal),
            button: textStyle(fontSize: 13, color: primaryColor_light, fontWeight: FontWeight.bold),
            caption: textStyle(fontSize: 14, color: reverseColor_light, fontWeight: FontWeight.normal),
            overline: textStyle(color: Colors.blue,fontSize: 14,fontWeight: FontWeight.bold)
          )),
      initialRoute: '/',
      routes: {
        '/': (ctx) => Home(),
        PostEditing.postEditing: (ctx) => const PostEditing(),
        NewsDetails.newsDetailsScreen: (ctx) => const NewsDetails(),
        TitleEditing.titleEditing : (ctx) => const TitleEditing(),
        AboutApplication.aboutApplication: (ctx) => const AboutApplication(),
        ApplicationSetting.applicationSetting: (ctx) => const ApplicationSetting(),
       /*   AddTitleBar.addTitleBar: (ctx) => const AddTitleBar(),
*/
      },
    );
  }
}
