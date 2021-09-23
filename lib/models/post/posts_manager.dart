import 'dart:async';
import 'dart:collection';

import 'package:newsapplication/models/title/news_title.dart';
import 'package:newsapplication/models/title/news_titles_manager.dart';
import 'package:provider/provider.dart';

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
  // RefreshController refreshController=RefreshController(initialRefresh: false);
  List<NewsTitle> titlesList = [];

  void update(List<NewsTitle> titlesList){
    this.titlesList=titlesList;
    notifyListeners();
  }




  Future<void> insertPost({required Post post}) async {
    print(post.title);
  }

  Future<void> updatePost({required Post post}) async {}

  Future<void> deletePost({required Post post}) async {}
int id1=1;
int id2=100;
  Future<void> fetchPosts(
      {
      uri =
          'http://192.168.1.101:8000/api/v1/post/fetch-posts?API_PASSWORD=PVd09uByztpJ8clnnTCc4J'}) async {
    var url = Uri.parse(uri);
    var response = await http.post(url);
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      var data = jsonResponse['post']['data'] as List<dynamic>;
      nextPage=jsonResponse['post']['next_page_url'];
      data.forEach((post) {
        if(postsList.where((element) => element.id==int.parse(post['id'].toString())).isEmpty==true)
        postsList.add(Post(
            id: int.parse(post['id'].toString()),
            title: post['title'],
            detail: post['detail'] ?? null,
            date: post['created_at'] ?? null,
            type: titlesList
                    .firstWhereOrNull(
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
    notifyListeners();
  }

  Future<void> onLoading() async {
    if(nextPage!=null)
  await  fetchPosts(uri: nextPage);
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
  }
}
