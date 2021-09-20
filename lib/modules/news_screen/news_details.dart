import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:newsapplication/layout/main_layout/main_layout.dart';
import 'package:newsapplication/models/post/post.dart';
import 'package:newsapplication/models/post/posts_manager.dart';
import 'package:newsapplication/modules/post_editing/post_editing.dart';
import 'package:newsapplication/shared/components/components.dart';
import 'package:newsapplication/shared/components/constants.dart';
import 'package:newsapplication/shared/image_viewer/image_viewer.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart' as localization;
import 'package:favorite_button/favorite_button.dart';

class NewsDetails extends StatefulWidget {
  const NewsDetails({Key? key}) : super(key: key);
  static String newsDetailsScreen = "/newsDetailsScreen";

  @override
  _NewsDetailsState createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  @override
  Widget build(BuildContext context) {
    Post post = ModalRoute.of(context)!.settings.arguments as Post;
    return defaultScaffold(
      title: "details".tr().toString(),
      context: context,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop({"isDelete": false, "id": ""});
        },
        icon: Icon(Icons.arrow_back_sharp),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            var isDelete = await defaultConfirmDialog(context: context);
            isDelete == true
                ? Navigator.of(context).pop({"isDelete": isDelete, "id": ''})
                : null;
          },
          icon: Icon(Icons.delete),
        ),
      ],
      body: Consumer<PostsManager>(
        builder: (context, value, child) => SingleChildScrollView(
        padding: const EdgeInsets.all(padding),
          child: Column(
            children: [
              Container(
                child: defaultSelectableText(
                  text: post.title.trim(),
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Container(
                height: post.remoteImageTitle != null ? 250 : 0,
                child: DefaultBoxImage(
                  images: post.remoteImageTitle != null
                      ? [post.remoteImageTitle]
                      : [],
                  index: 0,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Container(
                width: double.infinity,
                child: defaultSelectableText(
                  text: localization.DateFormat(timeFormat)
                      .format(DateTime.parse(value.postsList[0].date)),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Divider(
                thickness: 1.0,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Container(
                child: defaultSelectableText(
                  text: value.postsList[0].detail?.trim() ?? '',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Divider(
                thickness: 1.0,
              ),
              PhotoViewer(
                images: value.postsList[0].remoteImageList,
                onDismissed: (_) {},
              ),
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 20),
                  child: StarButton(
                    isStarred:
                        value.favoritePostsList.contains(value.postsList[0]),
                    valueChanged: (favoriteStatus) {
                      value.favoritePost(
                          post: value.postsList[0],
                          favoriteStatus: favoriteStatus);
                    },
                  )),
            ],
          ),
        ),
      ),
      floatingActionButton: defaultFloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(PostEditing.postEditing,
              arguments: Post(
                  id: post.id,
                  title: post.title,
                  detail: post.detail,
                  date: post.date,
                  type: post.type,
                  isRead: post.isRead,
                  isSync: post.isSync,
                  isFavorite: post.isFavorite,
                  remoteImageTitle: post.remoteImageTitle,
                  remoteImageList: post.remoteImageList));
        },
        icon: Icons.edit,
      ),
    );
  }
}
