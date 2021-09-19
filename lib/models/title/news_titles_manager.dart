import 'package:flutter/material.dart';
import 'news_title.dart';

class NewsTitlesManager with ChangeNotifier {
  List<NewsTitle> titlesList = [];

  Future<dynamic> insertTitle({required String title}) async {
    print("$title");
  }

  Future<dynamic> updateTitle({required int id}) async {}

  Future<dynamic> deleteTitle({required int id}) async {}

  Future<void> fetchTitle() async {}
}
