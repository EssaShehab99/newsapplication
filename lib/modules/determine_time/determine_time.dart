import 'dart:async';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsapplication/shared/components/components.dart';
import '/shared/components/constants.dart';

class DetermineTime extends StatefulWidget {
  final DateTime dateTime;

  DetermineTime(this.dateTime);

  @override
  State<DetermineTime> createState() => _DetermineTimeState();
}

class _DetermineTimeState extends State<DetermineTime> {
  Timer? _timer;
  DateTime? dateTime;

  @override
  void initState() {
    startTimer();
    dateTime = widget.dateTime;
    super.initState();
  }

  startTimer() {
    _timer = Timer(Duration(minutes: 1), () => setState(() {}));
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String textTime = "";
    if (DateTime.now().difference(dateTime!).inMinutes < 1) {
      return Builder(builder: (context) {
        return Text("now".tr().toString(),
            style: textStyle(fontSize: 13,color: Colors.blue));
      });
    } else if (DateTime.now().difference(dateTime!).inMinutes == 1) {
      return Builder(builder: (context) {
        return Text("oneMinute".tr().toString(),
            style: textStyle(fontSize: 13,color: Colors.blue));
      });
    } else if (DateTime.now().difference(dateTime!).inMinutes <= 10) {
      textTime = (DateTime.now().difference(dateTime!).inMinutes).toString() +
          "minutes".tr().toString();
    } else if (DateTime.now().difference(dateTime!).inMinutes > 10 &&
        DateTime.now().difference(dateTime!).inHours < 1) {
      textTime = (DateTime.now().difference(dateTime!).inMinutes).toString() +
          "minute".tr().toString();
    } else if (DateTime.now().difference(dateTime!).inHours == 1) {
      textTime = "sinceHour".tr().toString();
    } else if (DateTime.now().difference(dateTime!).inHours < 24) {
      textTime = "since".tr().toString() +
          (DateTime.now().difference(dateTime!).inHours).toString() +
          "hours".tr().toString();
    } else if (DateTime.now().difference(dateTime!).inDays == 1) {
      textTime = "sinceOneDay".tr().toString();
    } else if (DateTime.now().difference(dateTime!).inDays <= 10) {
      textTime = "since".tr().toString() +
          (DateTime.now().difference(dateTime!).inDays).toString() +
          "day".tr().toString();
    } else {
      textTime = DateFormat(timeFormat).format(dateTime!);
    }

    return Builder(
      builder: (context) {
        return Text(textTime, style: Theme.of(context).textTheme.headline2);
      },
    );
  }
}
