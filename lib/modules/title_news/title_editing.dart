import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:newsapplication/layout/main_layout/main_layout.dart';
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
  List<NewsTitle> newsTitleList=[];

  @override
  Widget build(BuildContext context) {
    newsTitleList= Provider.of<NewsTitlesManager>(
        context,
        listen: false)
        .titlesList;
    return defaultScaffold(
        title: "addTitle".tr().toString(),
        context: context,
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _formKeyTitle,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: defaultTextFormField(
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async =>
                    await Provider.of<NewsTitlesManager>(context, listen: false)
                        .fetchTitle(),
                child: ListView.builder(
                    itemBuilder: (context, index) => defaultItemListView(
                      onLongPress: () async {
                        var isDelete = await defaultConfirmDialog(
                            context: context);
                        isDelete == true
                            ? print("true")
                            : print("false");
                      },
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _title.text = newsTitleList[index]
                              .title;
                          setState(() {
                            isNew = false;
                          });
                        });
                      },
                      child: defaultAutoSizeText(
                      text:  "${newsTitleList[index].title}",
                        textAlign: TextAlign.justify,
                        context: context,
                      ),
                    ),
                    itemCount: newsTitleList.length),
              ),
            )
          ],
        ));
  }

  _submit() {}
}
