import 'post.dart';

import 'package:flutter/material.dart';

class PostsManager with ChangeNotifier {
  bool isUpload=false;
  List<Post> postsList = [];

  Future<void> insertPost({required Post post}) async {}

  Future<void> updatePost({required Post post}) async {}

  Future<void> deletePost({required Post post}) async {}

  Future<void> fetchPosts() async {}

  Future<void> fetchPost({required Post post}) async {}

  Future<void> changePostStatus({required Post post}) async {}

  Future<void> uploadImageTitlePost({required Post post}) async {}

  Future<void> uploadImageListPost({required Post post}) async {}

  Future<void> downloadImage({required String imageUrl,required int id}) async {
    postsList[id].localImageList?.add('sdfdfv');
    notifyListeners();
  }
}
