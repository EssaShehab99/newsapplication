import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:newsapplication/layout/main_layout/main_layout.dart';
import 'package:newsapplication/models/post/posts_manager.dart';
import 'package:newsapplication/models/title/news_title.dart';
import 'package:newsapplication/models/title/news_titles_manager.dart';
import 'package:newsapplication/shared/components/components.dart';
import 'package:provider/provider.dart';

class PostEditing extends StatefulWidget {
  const PostEditing({Key? key}) : super(key: key);
  static String postEditing = "/postEditing";

  @override
  _PostEditingState createState() => _PostEditingState();
}

class _PostEditingState extends State<PostEditing> {
  final GlobalKey<FormState> _formKeyTitle = GlobalKey();
  late TextEditingController _title = TextEditingController(text: "");
  late TextEditingController _detail = TextEditingController(text: "");
  NewsTitle? _postTpe;
  final focus = FocusNode();

  Future<void> _submit(BuildContext context) async {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    List<NewsTitle> titlesList=   Provider.of<NewsTitlesManager>(context,listen: true).titlesList;
    return defaultScaffld(
      title: "addPost".tr().toString(),
      context: context,
      body: Container(
        child: Provider.of<PostsManager>(context, listen: true).isUpload
            ? Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFadingCircle(
                      color: Theme.of(context).primaryColorDark,
                    ),
                    Center(
                      child: Text(
                        "dataUploading".tr().toString(),
                      ),
                    )
                  ],
                ),
              )
            : Container(
          padding: EdgeInsets.all(15),
                child: Form(
                  key: _formKeyTitle,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          child: defaultTextFormField(
                            context: context,
                            textEditingController: _title,
                            hintText: "title".tr().toString(),
                            keyboardType: TextInputType.text,
                            onChanged: (_) => setState(() {}),
                            validator: (String? value) {
                              if (value != null && value.trim().isEmpty ||
                                  value == null)
                                return "mustEnterText".tr().toString();
                              return null;
                            },
                            onSaved: (_) => _submit(context),
                            textInputAction: TextInputAction.next,
                            focusNode: focus,
                            maxLength: 200,
                          ),
                        ),

                        Container(
                          child: defaultTextFormField(
                            context: context,
                            textEditingController: _detail,
                            hintText: "details".tr().toString(),
                           onFieldSubmitted: (_){
                             FocusScope.of(context).unfocus();
                           },
                            onChanged: (_) => setState(() {}),
                            maxLength: 20000,
                          ),
                        ),

                        Container(
                          child: defaultDropdownButton(
                            context: context,
                            list:  titlesList,
                            value:titlesList[0],
                            onChanged: (value){
                              _postTpe=value;
                            }
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
