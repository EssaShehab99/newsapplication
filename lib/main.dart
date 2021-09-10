import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
      initialRoute: '/',
      routes: {
        '/': (ctx) => Home(),
/*
        AddPost.addPostScreen: (ctx) => const AddPost(),
        AppSetting.appSettingScreen: (ctx) => const AppSetting(),
        About.aboutScreen: (ctx) => const About(),
        NewsDetails.newsDetailsScreen: (ctx) => const NewsDetails(),
        ImageControl.imageControlScreen: (ctx) => const ImageControl(),
        AddTitleBar.addTitleBar: (ctx) => const AddTitleBar(),
*/
      },
    );
  }
}

