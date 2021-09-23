import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:newsapplication/layout/main_layout/main_layout.dart';
import 'package:newsapplication/shared/components/components.dart';
import 'package:newsapplication/shared/components/constants.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutApplication extends StatelessWidget {
  const AboutApplication({Key? key}) : super(key: key);
  static String aboutApplication = "/aboutApplication";

  @override
  Widget build(BuildContext context) {
    return defaultScaffold(
      context: context,
      title: "about-application".tr().toString(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: defaultImageLogo(fit: BoxFit.cover),
          ),
          Container(
            child: Center(
              child: Column(
                children: [
                  Text(
                    "version".tr().toString(),
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Text(
                    version,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () async {
                    Share.share(shareText);
                  },
                  icon: Icon(Icons.share),
                ),
                IconButton(
                  onPressed: () async {
                    try {
                      bool launched =
                          await launch(telegramUrl, forceSafariVC: false);

                      if (!launched) {
                        await launch(telegramUrl, forceSafariVC: false);
                      }
                    } catch (e) {
                      await launch(telegramUrl, forceSafariVC: false);
                    }
                  },
                  icon: Icon(Icons.send),
                ) // icon
              ],
            ),
          )
        ],
      ),
    );
  }
}
