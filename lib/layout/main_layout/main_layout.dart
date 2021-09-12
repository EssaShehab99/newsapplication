import 'package:flutter/material.dart';

Scaffold defaultScaffld(
        {required Widget body, FloatingActionButton? floatingActionButton,required BuildContext context,String? title}) =>
    Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            "$title",
          ),
        ),
        body: body,
        floatingActionButton: floatingActionButton);
