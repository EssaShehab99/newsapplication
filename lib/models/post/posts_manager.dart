import 'package:collection/src/iterable_extensions.dart';

import 'post.dart';

import 'package:flutter/material.dart';

class PostsManager with ChangeNotifier {
  bool isUpload=false;
  List<Post> postsList = [];
  List<Post> favoritePostsList = [];
  List<Map<String,String>> localImages=[];
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
  }
  Future<void> insertPost({required Post post}) async {}

  Future<void> updatePost({required Post post}) async {}

  Future<void> deletePost({required Post post}) async {}

  Future<void> fetchPosts() async {}

  Future<void> fetchPost({required Post post}) async {}

  Future<void> changePostStatus({required Post post}) async {}

  Future<void> uploadImageTitlePost({required Post post}) async {}

  Future<void> uploadImageListPost({required Post post}) async {}

  Future<void> downloadImage({required String remoteUrl,required String localUrl}) async {
    localImages.add({remoteUrl:localUrl});
    if(!_isDisposed){
      notifyListeners();
    }
  }
  void favoritePost({required Post post, required bool favoriteStatus}) {
    if(favoriteStatus)favoritePostsList.add(post);
    else favoritePostsList.remove(post);
  }
  String? imageLocalUrl(imageUrl) {
    Map<String, String>? localPath = localImages.firstWhereOrNull((localImage) => localImage.containsKey(imageUrl));
    if(localPath!=null){
      return localPath[imageUrl];
    }else return null;

  }
}
