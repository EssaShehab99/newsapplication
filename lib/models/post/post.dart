import '../title/news_title.dart';

class Post {
  String? id;
  final String title;
  final String? detail;
  final String date;
  final NewsTitle type;
  final bool isRead;
  final bool isSync;
  bool isFavorite;
  final String? imageTitle;
  final List<String>? imageList;

  Post({
    this.id,
    required this.title,
    required this.detail,
    required this.date,
    required this.type,
    required this.isRead,
    required this.isSync,
    required this.isFavorite,
    required this.imageTitle,
    required this.imageList,
  });
}


