import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:newsapplication/modules/post_editing/post_editing.dart';
import 'package:newsapplication/shared/components/components.dart';
import 'package:newsapplication/shared/components/constants.dart';
import '../shared/setting/application_setting.dart';
import 'package:provider/provider.dart';

import 'models/post/favorite_posts_manager.dart';
import 'models/post/posts_manager.dart';
import 'models/title/news_titles_manager.dart';
import 'modules/home/home.dart';

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
          ChangeNotifierProvider(create: (_) => ApplicationSetting()),
          ChangeNotifierProvider(create: (_) => NewsTitlesManager()),
          ChangeNotifierProvider(create: (_) => FavoritePostManager()),
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
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
          fontFamily: "Cairo",
          primaryColor: primaryColor_light,
          backgroundColor: secondaryColor_light,
        indicatorColor: secondaryColor_light,
          tabBarTheme: TabBarTheme(
            labelColor: reverseColor_light,
            unselectedLabelColor: secondaryColor_light,
            labelStyle: textStyle(fontSize: 15,color: reverseColor_light),
            unselectedLabelStyle: textStyle(fontSize: 13,color: secondaryColor_light),
          ),
          appBarTheme: AppBarTheme(
              color: primaryColor_light,
            centerTitle: true,
            titleTextStyle: textStyle(color: reverseColor_light),
            iconTheme: IconThemeData(
                color: reverseColor_light
            ),
          ),
          textTheme: TextTheme(
            headline1: textStyle(fontSize: 15,color: reverseColor_light),
            headline2: textStyle(fontSize: 13,color: reverseColor_light),
            headline3: textStyle(fontSize: 10,color: reverseColor_light),
            headline4: textStyle(fontSize: 15,color: secondaryColor_light),
          )),
      initialRoute: '/',
      routes: {
        '/': (ctx) => Home(),

        PostEditing.postEditing: (ctx) => const PostEditing(),
  /*      AppSetting.appSettingScreen: (ctx) => const AppSetting(),
        About.aboutScreen: (ctx) => const About(),
        NewsDetails.newsDetailsScreen: (ctx) => const NewsDetails(),
        ImageControl.imageControlScreen: (ctx) => const ImageControl(),
        AddTitleBar.addTitleBar: (ctx) => const AddTitleBar(),
*/
      },
    );
  }
}
