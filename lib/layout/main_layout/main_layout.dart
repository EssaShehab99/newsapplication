import 'package:flutter/material.dart';

Scaffold defaultScaffold(
        {required Widget body,
        Widget? floatingActionButton,
        required BuildContext context,
        String? title,
        leading = null,
        actions = null}) =>
    Scaffold(
        appBar: (title != null || actions != null || leading != null)
            ? AppBar(
                title: Text(
                  "$title",
                ),
                leading: leading,
                actions: actions,
                centerTitle: true,
              )
            : null,
        backgroundColor: Theme.of(context).primaryColor,
        body: body,
        floatingActionButton: floatingActionButton);
