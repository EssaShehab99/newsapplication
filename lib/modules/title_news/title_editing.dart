import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:newsapplication/layout/main_layout/main_layout.dart';
import 'package:newsapplication/models/post/posts_manager.dart';
import 'package:newsapplication/models/title/news_title.dart';
import 'package:newsapplication/models/title/news_titles_manager.dart';
import 'package:newsapplication/shared/components/components.dart';
import 'package:provider/provider.dart';

class TitleEditing extends StatefulWidget {
  const TitleEditing({Key? key}) : super(key: key);
  static String titleEditing = "/titleEditing";

  @override
  _TitleEditingState createState() => _TitleEditingState();
}

class _TitleEditingState extends State<TitleEditing> {
  final GlobalKey<FormState> _formKeyTitle = GlobalKey();
  TextEditingController _title = TextEditingController();

  final focus = FocusNode();
  bool isNew = true;
  List<NewsTitle> newsTitleList = [];

  @override
  Widget build(BuildContext context) {
    newsTitleList =
        Provider.of<NewsTitlesManager>(context, listen: false).titlesList;
    return defaultScaffold(
        title: "addTitle".tr().toString(),
        context: context,
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.all(5),
              child: Form(
                key: _formKeyTitle,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: defaultTextFormField(
                        key: '3',
                        textEditingController: _title,
                        focusNode: focus,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).unfocus();
                          if (_title.text.isEmpty && !isNew) {
                            setState(() {
                              isNew = true;
                            });
                          }
                        },
                        validator: (text) {
                          if (!text!.trim().isNotEmpty) {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              isNew = true;
                            });
                            return "mustEnterText".tr().toString();
                          }
                          return null;
                        },
                        onSaved: (_) => _submit(),
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          setState(() {});
                        },
                        context: context,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      child: defaultElevatedButton(
                        onPressed: _submit,
                        child: Text(
                          isNew
                              ? "add".tr().toString()
                              : "edit".tr().toString(),
                          style: Theme.of(context).textTheme.headline1,
                          // style: StyleAndText.textStyleButton,
                        ),
                        width: 70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Consumer<PostsManager>(builder: (context, value, child) {
                // value.refreshController =
                //     RefreshController(initialRefresh: false);
                return ListView.builder(
                      itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              children: [
                                defaultDivider(),
                                defaultItemListView(
                                  onPressed: () {},
                                  child: defaultDismissible(
                                    key: index.toString(),
                                    direction: DismissDirection.horizontal,
                                    onDismissed:
                                        (DismissDirection direction) async {},
                                    confirmDismiss: (direction) async {
                                      if (direction ==
                                          DismissDirection.startToEnd) {
                                        FocusScope.of(context).unfocus();
                                        var isDelete =
                                            await defaultConfirmDialog(
                                                context: context);
                                      } else {
                                        _title.text =
                                            newsTitleList[index].title;
                                        _title.selection =
                                            TextSelection.fromPosition(
                                                TextPosition(
                                                    offset:
                                                        _title.text.length));
                                        isNew = false;
                                        setState(() {});
                                        return await false;
                                      }
                                    },
                                    child: Container(
                                      height: 50,
                                      child: Center(
                                        child: defaultAutoSizeText(
                                          text: "${newsTitleList[index].title}",
                                          textAlign: TextAlign.justify,
                                          context: context,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      itemCount: newsTitleList.length);
              }),
            )
          ],
        ));
  }

  void  _submit() {
    FocusScope.of(context).unfocus();
    if(_formKeyTitle.currentState?.validate()==true) {
      _title.clear();
      Provider.of<NewsTitlesManager>(context, listen: false)
          .insertTitle(title: _title.text);
    }
    else
      FocusScope.of(context).requestFocus(focus);
  }
}
