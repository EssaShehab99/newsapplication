import 'dart:async';
import 'dart:io';

import 'package:newsapplication/models/title/news_title.dart';

import 'post.dart';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

class PostsManager with ChangeNotifier {
  bool isUpload = false;
  List<Post> postsList = [];
  List<Post> favoritePostsList = [];
  String? nextPage;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }  // RefreshController refreshController=RefreshController(initialRefresh: false);
  List<NewsTitle> titlesList = [];

  void update(List<NewsTitle> titlesList) {
    this.titlesList = titlesList;
    if (!_isDisposed) {
      super.notifyListeners();
    }  }

  Future<void> insertPost({required Post post}) async {
    print(post.title);
  }

  Future<void> updatePost({required Post post}) async {}

  Future<void> deletePost({required Post post}) async {}

  Future<void> fetchPosts(
      {uri =
          'http://192.168.1.101:8000/api/v1/post/fetch-posts?API_PASSWORD=PVd09uByztpJ8clnnTCc4J'}) async {
    try {
      var url = Uri.parse(uri);
      var response = await http.post(url).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        var data = jsonResponse['post']['data'] as List<dynamic>;
        nextPage = jsonResponse['post']['next_page_url'];
        data.forEach((post) {
          if (postsList
                  .where((element) =>
                      element.id == int.parse(post['id'].toString()))
                  .isEmpty ==
              true)
            postsList.add(Post(
                id: int.parse(post['id'].toString()),
                title: post['title'],
                detail: post['detail'] ?? null,
                date: post['created_at'] ?? null,
                type: titlesList.firstWhereOrNull(
                        (element) => element.id == post['type']) ??
                    null,
                isRead: false,
                isSync: true,
                isFavorite: false,
                remoteImageTitle: post['titleimageUrl'] ?? null,
                remoteImageList:
                    List<String>.from(post['imageUrl'] ?? <String>[])));
        });
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
    } on SocketException catch (e) {
      print('Socket Error: $e');
    } on Error catch (e) {
      print('General Error: $e');
    }
    if (!_isDisposed) {
      super.notifyListeners();
    }  }

  Future<void> onLoading() async {
    if (nextPage != null) await fetchPosts(uri: nextPage);
    print(nextPage);
  }

  Future<void> changePostStatus({required Post post}) async {}

  Future<void> uploadImageTitlePost({required Post post}) async {}

  Future<void> uploadImageListPost({required Post post}) async {}

  void favoritePost({required Post post, required bool favoriteStatus}) {
    if (favoriteStatus)
      favoritePostsList.add(post);
    else
      favoritePostsList.remove(post);
    if (!_isDisposed) {
      super.notifyListeners();
    }  }

  bool checkFavoritePost({required int id}) {
    print('id :' + id.toString());
    return favoritePostsList.firstWhereOrNull((element) => element.id == id) ==
            null
        ? false
        : true;
  }
}
