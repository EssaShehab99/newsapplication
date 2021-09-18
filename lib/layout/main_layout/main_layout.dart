import 'package:flutter/material.dart';

Scaffold defaultScaffld(
        {required Widget body,
        Widget? floatingActionButton,
        required BuildContext context,
        String? title,
        leading = null,
        actions = null}) =>
    Scaffold(
        appBar: (title != null || actions != null || leading != null)
            ? AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                title: Text(
                  "$title",
                ),
                leading: leading,
                actions: actions,
                centerTitle: true,
              )
            : null,
        body: body,
        floatingActionButton: floatingActionButton);
