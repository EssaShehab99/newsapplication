import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapplication/layout/main_layout/main_layout.dart';
import 'package:newsapplication/models/post/favorite_posts_manager.dart';
import 'package:newsapplication/models/post/post.dart';
import 'package:newsapplication/models/post/posts_manager.dart';
import 'package:newsapplication/modules/about_application/about_application.dart';
import 'package:newsapplication/modules/application_setting/application_setting.dart';
import 'package:newsapplication/modules/determine_time/determine_time.dart';
import 'package:newsapplication/modules/post_editing/post_editing.dart';
import 'package:newsapplication/modules/title_news/title_editing.dart';
import 'package:newsapplication/shared/components/components.dart';
import 'package:newsapplication/shared/components/constants.dart';
import 'package:newsapplication/shared/image_viewer/image_viewer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '/models/title/news_titles_manager.dart';
import 'package:provider/provider.dart';

import 'news_details.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _posts = Provider.of<PostsManager>(context, listen: true).postsList;
    var _titles =
        Provider.of<NewsTitlesManager>(context, listen: true).titlesList;
    var _favoritePosts = Provider.of<FavoritePostManager>(context, listen: true)
        .favoritePostsList;
    return defaultScaffold(
      context: context,
      body: SafeArea(
        child: DefaultTabController(
          length: _titles.length,
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverSafeArea(
                  sliver: SliverAppBar(
                    leading: Container(
                        width: 120,
                        child: defaultImageLogo(fit: BoxFit.contain)),
                    leadingWidth: 120,
                    actions: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 0.0),
                        child: PopupMenuButton(
                          icon: Icon(
                            Icons.more_vert,
                          ),
                          shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
                          itemBuilder: (ctx) {
                            final list = <PopupMenuEntry<int>>[];
                            itemsPopupMenuButton.forEach((itemPopupMenuButton) {
                              list.add(PopupMenuItem(
                                child: Text(
                                  itemPopupMenuButton,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                value: itemsPopupMenuButton
                                    .indexOf(itemPopupMenuButton),
                              ));
                              list.add(
                                const PopupMenuDivider(
                                  height: 5,
                                ),
                              );
                            });
                            return list;
                          },
                          onSelected: (item) {
                            if (item == 0)
                              Navigator.of(context).pushNamed(
                                  ApplicationSetting.applicationSetting);
                            if (item == 1)
                              Navigator.of(context)
                                  .pushNamed(AboutApplication.aboutApplication);
                            if (item == 2)
                              Navigator.of(context)
                                  .pushNamed(TitleEditing.titleEditing);

                            // if (item == 3) exit(0);
                          },
                        ),
                      )
                    ],
                    expandedHeight: 120,
                    pinned: true,
                    floating: true,
                    snap: true,
                    forceElevated: innerBoxIsScrolled,
                    bottom: TabBar(
                      isScrollable: true,
                      tabs: _titles
                          .map((title) => Tab(text: title.title))
                          .toList(),
                    ),
                  ),
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
                            builder: (context) {
                              return Consumer<PostsManager>(
                                builder: (context, value, child) {
                                  value.refreshController =
                                      RefreshController(initialRefresh: false);
                                  return defaultSmartRefresher(
                                    controller: value.refreshController!,
                                    onRefresh: value.onRefresh,
                                    onLoading: value.onLoading,
                                    child: CustomScrollView(
                                      key: PageStorageKey<String>(
                                          _newsTitle.id!),
                                      slivers: [
                                        SliverOverlapInjector(
                                            handle: NestedScrollView
                                                .sliverOverlapAbsorberHandleFor(
                                                    context)),
                                        SliverPadding(
                                          padding: EdgeInsets.all(2.0),
                                          sliver: SliverList(
                                            delegate:
                                                SliverChildBuilderDelegate(
                                              (context, index) => _newsTitle
                                                          .typeTitle ==
                                                      TypeTitle.MIXED
                                                  ? _listViewBuilder(
                                                      _posts, index)
                                                  : (_newsTitle.typeTitle ==
                                                          TypeTitle.CLOUD
                                                      ? (_listViewBuilder(
                                                          _posts
                                                              .where((_post) =>
                                                                  _post.type
                                                                      .id ==
                                                                  _newsTitle.id)
                                                              .toList(),
                                                          index))
                                                      : _listViewBuilder(
                                                          _favoritePosts,
                                                          index)),
                                              childCount: _newsTitle
                                                          .typeTitle ==
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
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
      floatingActionButton: defaultFloatingActionButton(
        icon: Icons.edit,
        onPressed: () {
          Navigator.of(context).pushNamed(PostEditing.postEditing);
        },
      ),
    );
  }

  Widget _listViewBuilder(List<Post> _posts, index) => Column(children: [
        defaultDivider(),
        defaultItemListView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: defaultAutoSizeText(
                            text: "${_posts[index].title}",
                            context: context,
                          ),
                        ),
                      ),
                      Container(
                        width:
                            _posts[index].remoteImageTitle != null ? 120 : 0.0,
                        height:
                            _posts[index].remoteImageTitle != null ? 120 : 0.0,
                        child: DefaultBoxImage(
                          images: _posts[index].remoteImageTitle != null
                              ? [_posts[index].remoteImageTitle]
                              : [],
                          index: 0,
                        ),
                      ),
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
            onPressed: () {
              Navigator.of(context).pushNamed(NewsDetails.newsDetailsScreen,
                  arguments: _posts[index]);
            })
      ]);
}
