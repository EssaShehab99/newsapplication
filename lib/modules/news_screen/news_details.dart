import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:newsapplication/models/post/post.dart';
import 'package:newsapplication/models/post/posts_manager.dart';
import 'package:newsapplication/shared/components/components.dart';
import 'package:newsapplication/shared/components/constants.dart';
import 'package:newsapplication/shared/image_viewer/image_viewer.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
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
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColorDark,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            "details".tr().toString(),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop({"isDelete": false, "id": ""});
            },
            icon: Icon(Icons.arrow_back_sharp),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                var isDelete = await defaultConfirmDialog(context: context);
                isDelete == true
                    ? Navigator.of(context)
                        .pop({"isDelete": isDelete, "id": ''})
                    : null;
              },
              icon: Icon(Icons.delete),
            ),
          ]),
      body: Consumer<PostsManager>(
        builder: (context, value, child) => SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  child: SelectableText(
                    value.postsList[0].title,
                    style: Theme.of(context).textTheme.bodyText1,
                    textDirection: intl.Bidi.detectRtlDirectionality(
                            value.postsList[0].title)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    textAlign: TextAlign.justify,
                    toolbarOptions: ToolbarOptions(
                      copy: true,
                      selectAll: true,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: SelectableText(
                    localization.DateFormat(timeFormat)
                        .format(DateTime.parse(value.postsList[0].date)),
                    style: Theme.of(context).textTheme.headline2,
                    toolbarOptions: ToolbarOptions(
                      copy: true,
                      selectAll: true,
                    ),
                  ),
                ),
                Divider(
                  thickness: 1.0,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                PhotoViewer(
                    images: [value.postsList[0].remoteImageTitle],
                    onDismissed: (_) {},
                    enableInfiniteScroll: false),
                SizedBox.shrink(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Container(
                  child: SelectableText(
                    value.postsList[0].detail ?? '',
                    style: Theme.of(context).textTheme.headline3,
                    textAlign: TextAlign.justify,
                    textDirection: intl.Bidi.detectRtlDirectionality(
                            value.postsList[0].title)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    toolbarOptions: ToolbarOptions(
                      copy: true,
                      selectAll: true,
                    ),
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
                    onDismissed: (_) {}),
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 20),
                    child: StarButton(
                      isStarred:
                          value.favoritePostsList.contains(value.postsList[0]),
                      valueChanged: (favoriteStatus) {
                        print(Provider.of<PostsManager>(context, listen: false)
                                .localImages[0]
                            [value.postsList[0].remoteImageTitle]);
                        value.favoritePost(
                            post: value.postsList[0],
                            favoriteStatus: favoriteStatus);
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.of(context).pushNamed(AddPost.addPostScreen, arguments: {
          //   "isNew": false,
          //   "post": Post(
          //       id: argumentPassed.id,
          //       title: argumentPassed.title,
          //       detail: argumentPassed.detail,
          //       date: argumentPassed.date,
          //       type: Provider.of<TitleBarList>(context, listen: false)
          //           .titleBarList
          //           .firstWhere(
          //               (element) => element.id == argumentPassed.type!.id),
          //       isRead: argumentPassed.isRead,
          //       isSync: argumentPassed.isSync,
          //       isFavorite: argumentPassed.isFavorite,
          //       imageTitle: argumentPassed.imageTitle,
          //       imageList: argumentPassed.imageList)
          // });
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
