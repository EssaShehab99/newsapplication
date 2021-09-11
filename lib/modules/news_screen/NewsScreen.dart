import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:newsapplication/models/post/favorite_posts_manager.dart';
import 'package:newsapplication/models/post/posts_manager.dart';
import 'package:newsapplication/modules/determine_time/determine_time.dart';
import 'package:newsapplication/shared/components/components.dart';
import 'package:newsapplication/shared/components/constants.dart';
import 'package:newsapplication/shared/setting/application_setting.dart';
import '/models/title/news_titles_manager.dart';
import 'package:provider/provider.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    var _posts = Provider.of<PostsManager>(context, listen: true).postsList;
    var _titles =
        Provider.of<NewsTitlesManager>(context, listen: true).titlesList;
    var _favoritePosts = Provider.of<FavoritePostManager>(context, listen: true)
        .favoritePostsList;
    SliverAppBar appBar = SliverAppBar(
      actions: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 0.0),
          child: PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (ctx) => List<PopupMenuItem<int>>.generate(
              itemsPopupMenuButton.length,
              (index) => PopupMenuItem(
                child: Text(
                  itemsPopupMenuButton[index],
                ),
                value:
                    itemsPopupMenuButton.indexOf(itemsPopupMenuButton[index]),
              ),
            ),
            onSelected: (item) {
              // if (item == 0)
              //   Navigator.of(context)
              //       .pushNamed(AppSetting.appSettingScreen);
              // if (item == 1)
              //   Navigator.of(context).pushNamed(About.aboutScreen);
              // if (item == 2)
              //   Navigator.of(context)
              //       .pushNamed(AddTitleBar.addTitleBar);
              // ;
              // if (item == 3) exit(0);
            },
          ),
        )
      ],
      title: Container(
        width: 120,
        child: defaultImageLogo(fit: BoxFit.contain),
      ),
      floating: true,
      pinned: true,
      snap: true,
      elevation: 5,
      bottom: TabBar(
        isScrollable: true,
        tabs: _titles.map((title) => Tab(text: title.title)).toList(),
      ),
    );
    return Scaffold(
      body: DefaultTabController(
        length: Provider.of<NewsTitlesManager>(context, listen: true)
            .titlesList
            .length,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverSafeArea(
                top: false,
                sliver: appBar,
              ),
            )
          ],
          body: TabBarView(
            children: _titles
                .map((_newsTitle) => Container(
                      color: Theme.of(context).backgroundColor,
                      child: SafeArea(
                        top: false,
                        bottom: false,
                        child: Builder(
                          builder: (BuildContext context) {
                            return NotificationListener(
                              onNotification: (scrollNotification) {
                                return true;
                              },
                              child: RefreshIndicator(
                                onRefresh: () async =>
                                    await Provider.of<PostsManager>(context,
                                            listen: false)
                                        .fetchPosts(),
                                child: CustomScrollView(
                                  key: PageStorageKey<String>(_newsTitle.id!),
                                  slivers: <Widget>[
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (context, index) => _newsTitle
                                                    .typeTitle ==
                                                TypeTitle.MIXED
                                            ? _listViewBuilder(_posts, index)
                                            : (_newsTitle.typeTitle ==
                                                    TypeTitle.CLOUD
                                                ? (_listViewBuilder(
                                                    _posts
                                                        .where((_post) =>
                                                            _post.type.id ==
                                                            _newsTitle.id)
                                                        .toList(),
                                                    index))
                                                : _listViewBuilder(
                                                    _favoritePosts, index)),
                                        childCount: _newsTitle.typeTitle ==
                                                TypeTitle.MIXED
                                            ? _posts.length
                                            : (_newsTitle.typeTitle ==
                                                    TypeTitle.CLOUD
                                                ? _posts
                                                    .where((_post) =>
                                                        _post.type.id ==
                                                        _newsTitle.id)
                                                    .length
                                                : _favoritePosts.length),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
      floatingActionButton:
          defaultFloatingActionButton(icon: Icons.edit, onPressed: () {}),
    );
  }

  Widget _listViewBuilder(_posts, index) => defaultItemListView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: FutureBuilder(
                          future: Provider.of<ApplicationSetting>(context,
                                  listen: false)
                              .startIdentifyingPossibleLanguages(
                                  _posts[index].title),
                          builder: (context, snapShot) {
                            return AutoSizeText(
                              "${_posts[index].title}",
                              style: Theme.of(context).textTheme.headline2,
                              textAlign: TextAlign.justify,
                              wrapWords: false,
                              textDirection: snapShot.hasData
                                  ? snapShot.data as TextDirection
                                  : TextDirection.rtl,
                              overflow: TextOverflow.fade,
                              maxLines: 5,
                            );
                          }),
                    ),
                  ),
                  Provider.of<ApplicationSetting>(context, listen: true)
                              .isImageLoad ==
                          true
                      ? (_posts[index].imageTitle == null
                          ? SizedBox.shrink()
                          : defaultImage(imageUrl: _posts[index].imageTitle))
                      : SizedBox.shrink(),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: DetermineTime(
                      DateTime.parse(_posts[index].date),
                    ),
                  ),
                  Spacer(),
                  _posts[index].isRead
                      ? SizedBox.shrink()
                      : Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              color: Colors.green, shape: BoxShape.circle),
                        ),
                ],
              ),
            ),
          ],
        ),
      );
}
