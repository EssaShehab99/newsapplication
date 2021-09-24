import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'post.dart';

class FavoritePostManager with ChangeNotifier {
List<Post> postsList = [];
// List<int> favoriteID = [];

Future<void> insertFavoritePost({required Post post}) async {}

Future<void> deleteFavoritePost({required Post post}) async {}

// List<Post>? fetchFavoritePosts()  {
//   List<Post>? favoritePostsList ;
//   favoriteID.forEach((favoriteID) {
//    favoritePostsList= postsList.firstWhereOrNull((post) => post.id==favoriteID) as List<Post>?;
//   });
//   return favoritePostsList;
// }
void update(List<Post> postsList) {

  this.postsList = postsList;
  notifyListeners();
}
}