import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:newsapplication/layout/main_layout/main_layout.dart';
import 'package:newsapplication/shared/components/components.dart';
import 'package:newsapplication/shared/setting/setting.dart';
import 'package:provider/provider.dart';

class ApplicationSetting extends StatefulWidget {
  const ApplicationSetting({Key? key}) : super(key: key);
  static String applicationSetting = "/applicationSetting";

  @override
  _ApplicationSettingState createState() => _ApplicationSettingState();
}

class _ApplicationSettingState extends State<ApplicationSetting> {
  @override
  Widget build(BuildContext context) {
    return defaultScaffold(
        title: "setting".tr().toString(),
        body: Consumer<Setting>(
          builder: (context, value, child) => ListView(
            children: [
              defaultListTile(groupTitle: "dataUsing".tr().toString(), groupElements: [
                CheckboxListTile(
                  title: Text(
                    "photos".tr().toString(),
                  ),
                  subtitle: Text(
                    "loadPhotosOnTheHomeScreen".tr().toString(),
                  ),
                  value: value.autoDownloadMedia,
                  onChanged: (onChangedValue) {
                    value.setAutoDownloadMedia(onChangedValue!);
                  },
                )
              ])
            ],
          ),
        ),
        context: context);
  }
}
