import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:newsapplication/layout/main_layout/main_layout.dart';
import 'package:newsapplication/shared/components/components.dart';
import 'package:newsapplication/shared/components/constants.dart';
import 'package:newsapplication/shared/setting/setting.dart';
import 'package:provider/provider.dart';

class ApplicationSetting extends StatefulWidget {
  const ApplicationSetting({Key? key}) : super(key: key);
  static String applicationSetting = "/applicationSetting";

  @override
  _ApplicationSettingState createState() => _ApplicationSettingState();
}

class _ApplicationSettingState extends State<ApplicationSetting> {
  int? _radioValue;

  @override
  Widget build(BuildContext context) {
    return defaultScaffold(
        title: "setting".tr().toString(),
        body: Consumer<Setting>(
            builder: (context, value, child) => SingleChildScrollView(
                padding: const EdgeInsets.all(padding),
                  child: Padding(
                    padding: const EdgeInsets.all(padding),
                    child: Column(
                      children: [
                        defaultGroupListTile(
                            groupTitle: "dataUsing".tr().toString(),
                            groupElements: [
                              Builder(
                                builder: (context) => CheckboxListTile(
                                  title: Text(
                                    "photos".tr().toString(),
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                  subtitle: Text(
                                    "loadPhotosOnTheHomeScreen".tr().toString(),
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  value: value.autoDownloadMedia,
                                  onChanged: (onChangedValue) {
                                    value.setAutoDownloadMedia(onChangedValue!);
                                  },
                                ),
                              ),
                            ]),
                        defaultGroupListTile(
                            groupTitle: "display".tr().toString(),
                            groupElements: [
                              defaultListTile(
                                  title: "theme".tr().toString(),
                                  subtitle: "${value.themeModeName!}",
                                  onTap: () {
                                    defaultDialog(
                                        context: context,
                                        height: 180,
                                        title: Consumer<Setting>(
                                          builder:(context, value, child) =>  Text(
                                            "theme".tr().toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3,
                                          ),
                                        ),
                                        child: Consumer<Setting>(
                                            builder: (context, value, child) =>
                                                Column(
                                                  children: themeItems
                                                      .map((themeItem) =>
                                                          RadioListTile<int>(
                                                            controlAffinity:
                                                                ListTileControlAffinity
                                                                    .leading,
                                                            value: themeItems
                                                                .indexOf(
                                                                    themeItem),
                                                            groupValue: value
                                                                .themeModeValue,
                                                            onChanged: (val) {
                                                                value
                                                                    .setThemeMode(
                                                                        val!);

                                                            },
                                                            title: Text(
                                                              themeItem,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline2,
                                                            ),
                                                          ))
                                                      .toList(),
                                                )));
                                  })
                            ]),
                        defaultGroupListTile(
                            groupTitle: "language".tr().toString(),
                            groupElements: [
                              defaultListTile(
                                  title: "language".tr().toString(),
                                  subtitle: "${value.languageName}",
                                  onTap: () {
                                    defaultDialog(
                                        context: context,
                                        height: 120,
                                        title: Text(
                                          "language".tr().toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3,
                                        ),
                                        child: Consumer<Setting>(
                                            builder: (context, value, child) =>
                                                Column(
                                                  children: value.languages()
                                                      .map((language) =>
                                                          RadioListTile<int>(
                                                            controlAffinity:
                                                                ListTileControlAffinity
                                                                    .leading,
                                                            value: value.languages()
                                                                .indexOf(
                                                                    language),
                                                            groupValue: value
                                                                .languageValue,
                                                            onChanged: (val) {
                                                                print('ttttttttttttttttttt${val}');
                                                                value
                                                                    .setLanguage(
                                                                        val!,context);

                                                            },
                                                            title: Text(
                                                              language,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline2,
                                                            ),
                                                          ))
                                                      .toList(),
                                                )));
                                  })
                            ]),
                      ],
                    ),
                  ),
                )),
        context: context);
  }
}
