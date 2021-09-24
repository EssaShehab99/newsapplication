import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapplication/models/post/posts_manager.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DefaultSmartRefresher extends StatefulWidget {
  DefaultSmartRefresher({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  _DefaultSmartRefresherState createState() => _DefaultSmartRefresherState();
}

class _DefaultSmartRefresherState extends State<DefaultSmartRefresher> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    if(mounted)
      await Provider.of<PostsManager>(context,listen: false).fetchPosts();
    print('_onRefresh');
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {

    await Provider.of<PostsManager>(context,listen: false).onLoading();
    print('_onLoading');

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (context, mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull-up-load".tr().toString());
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("load-failed-click-retry".tr().toString());
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release-to-load-more".tr().toString());
            } else {
              body = Text("no-more-data".tr().toString());
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: widget.child);
  }
}
