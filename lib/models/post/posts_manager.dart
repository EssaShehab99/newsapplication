import 'dart:async';
import 'dart:collection';

import 'package:newsapplication/models/title/news_title.dart';
import 'package:newsapplication/models/title/news_titles_manager.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'post.dart';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

class PostsManager with ChangeNotifier {
  bool isUpload = false;
  List<Post> postsList = [];
  List<Post> favoritePostsList = [];
  RefreshController? refreshController;

  Future<void> insertPost({required Post post}) async {
    print(post.title);
  }

  Future<void> updatePost({required Post post}) async {}

  Future<void> deletePost({required Post post}) async {}

  Future<void> fetchPosts(BuildContext context) async {
    print('fetching ..');
    var url = Uri.parse(
        'http://192.168.1.101:8000/api/v1/post/fetch-posts?API_PASSWORD=PVd09uByztpJ8clnnTCc4J');
    var response = await http.post(url);
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      var data = jsonResponse['post']['data'] as List<dynamic>;

      data.forEach((post) {
        postsList.add(Post(
            id: post['id'].toString(),
            title: post['title'],
            detail: post['detail']??null,
            date: post['created_at']??null,
            type: Provider.of<NewsTitlesManager>(context, listen: false)
                .titlesList
                .firstWhereOrNull((element) => element.id == post['type']),
            isRead: false,
            isSync: true,
            isFavorite: false,
            remoteImageTitle: post['titleimageUrl'],
            remoteImageList:
                List<String>.from(post['imageUrl'] ?? <String>[])));
      });
    }

    refreshController?.refreshCompleted();
    notifyListeners();
  }

  void onRefresh(context) async {
    await fetchPosts(context);
    // await Future.delayed(Duration(seconds: 2));
    // refreshController?.refreshCompleted();
    // notifyListeners();
  }

  void onLoading() async {
    // await Future.delayed(Duration(seconds: 2));
    // print("Shehab ");
    //
    refreshController?.loadComplete();
    notifyListeners();
  }

  Future<void> changePostStatus({required Post post}) async {}

  Future<void> uploadImageTitlePost({required Post post}) async {}

  Future<void> uploadImageListPost({required Post post}) async {}

  void favoritePost({required Post post, required bool favoriteStatus}) {
    if (favoriteStatus)
      favoritePostsList.add(post);
    else
      favoritePostsList.remove(post);
  }
}
