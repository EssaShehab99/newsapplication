import 'package:flutter/material.dart';

import 'post.dart';

class FavoritePostManager with ChangeNotifier {
List<Post> favoritePostsList = [];

Future<void> insertFavoritePost({required Post post}) async {}


Future<void> deleteFavoritePost({required Post post}) async {}

Future<void> fetchFavoritePosts() async {}
}