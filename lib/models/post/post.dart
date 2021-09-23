import '../title/news_title.dart';

class Post {
  int? id;
  final String title;
  final String? detail;
  final String date;
  final NewsTitle? type;
  final bool isRead;
  final bool isSync;
  bool isFavorite;
  final String? remoteImageTitle;
  final List<String>? remoteImageList;

  Post({
    this.id,
    required this.title,
    required this.detail,
    required this.date,
    required this.type,
    required this.isRead,
    required this.isSync,
    required this.isFavorite,
    required this.remoteImageTitle,
    required this.remoteImageList,
  });
}


