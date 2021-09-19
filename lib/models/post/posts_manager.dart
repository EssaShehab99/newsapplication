import 'dart:async';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'post.dart';

import 'package:flutter/material.dart';

class PostsManager with ChangeNotifier {
  bool isUpload=false;
  List<Post> postsList = [];
  List<Post> favoritePostsList = [];
  RefreshController? refreshController;
int counter=0;
  Future<void> insertPost({required Post post}) async {
    print(post.title);
  }

  Future<void> updatePost({required Post post}) async {}

  Future<void> deletePost({required Post post}) async {}

  Future<void> fetchPosts() async {
    counter++;

    await Future.delayed(Duration(milliseconds: 1000));
    print("Esss $counter sssa");
    refreshController?.refreshCompleted();

    await Future.delayed(Duration(milliseconds: 1000));

    refreshController?.loadComplete();
    notifyListeners();
  }
  void onRefresh() async{
    counter++;
    await Future.delayed(Duration(seconds: 2));
    print("Essa $counter");

    refreshController?.refreshCompleted();
    notifyListeners();
    print("Essa $counter");

  }

  void onLoading() async{
    counter++;
    await Future.delayed(Duration(seconds: 2));
    print("Shehab $counter");

    refreshController?.loadComplete();
    notifyListeners();

  }

  Future<void> changePostStatus({required Post post}) async {}

  Future<void> uploadImageTitlePost({required Post post}) async {}

  Future<void> uploadImageListPost({required Post post}) async {}


  void favoritePost({required Post post, required bool favoriteStatus}) {
    if(favoriteStatus)favoritePostsList.add(post);
    else favoritePostsList.remove(post);
  }

}
