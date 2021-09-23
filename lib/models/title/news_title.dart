import '/shared/components/constants.dart';

class NewsTitle {
  final int? id;
  final String title;
  TypeTitle typeTitle;
  bool? isSync;

  NewsTitle({required this.id, required this.title, required this.typeTitle});
}
