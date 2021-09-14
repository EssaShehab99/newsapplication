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
  final String? remoteImageTitle;
  final String? localImageTitle;
  final List<String>? remoteImageList;
  final List<String>? localImageList;

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
    required this.localImageTitle,
    required this.remoteImageList,
    required this.localImageList,
  });
}


