import 'dart:io';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:newsapplication/layout/main_layout/main_layout.dart';
import 'package:newsapplication/models/post/post.dart';
import 'package:newsapplication/models/post/posts_manager.dart';
import 'package:newsapplication/models/title/news_title.dart';
import 'package:newsapplication/models/title/news_titles_manager.dart';
import 'package:newsapplication/shared/components/components.dart';
import 'package:newsapplication/shared/components/constants.dart';
import 'package:newsapplication/shared/image_viewer/image_viewer.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

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
  NewsTitle? _postType;
  late String _id;
  final focus = FocusNode();
  List<dynamic>? _image = [];
  List<dynamic>? _images = [];
  bool isNew=true;

  void _submit() {
    print(_image?.length);
    FocusScope.of(context).unfocus();
    if (_formKeyTitle.currentState?.validate() == true)
      Provider.of<PostsManager>(context, listen: false).insertPost(
          post: Post(
              title: _title.text,
              detail: 'detail',
              date: 'DateTime.now()',
              type: NewsTitle(
                  id: '1', title: 'title', typeTitle: TypeTitle.FAVORITE),
              isRead: true,
              isSync: true,
              isFavorite: true,
              remoteImageTitle: 'remoteImageTitle',
              remoteImageList: ['remoteImageList']));
    else
      FocusScope.of(context).requestFocus(focus);
  }

  @override
  void didChangeDependencies() {
    Post? post = ModalRoute.of(context)!.settings.arguments as Post?;
    if (post != null) {
      _id = post.id!;
      _title.text = post.title;
      _detail.text = post.detail ?? '';
      _postType = post.type;
      _image=[post.remoteImageTitle];
      _images=post.remoteImageList;
      isNew=false;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List<NewsTitle> titlesList =
        Provider.of<NewsTitlesManager>(context, listen: true).titlesList;
    return defaultScaffold(
        title: "addPost".tr().toString(),
        context: context,
        body: Container(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Form(
              key: _formKeyTitle,
              child: Column(
                children: [
                  Container(
                    child: defaultTextFormField(
                      context: context,
                      key: '1',
                      textEditingController: _title,
                      hintText: "title".tr().toString(),
                      keyboardType: TextInputType.multiline,
                      onChanged: (_) => setState(() {}),
                      validator: (String? value) {
                        if (value != null && value.trim().isEmpty ||
                            value == null)
                          return "mustEnterText".tr().toString();
                        return null;
                      },
                      onSaved: (_) => _submit,
                      textInputAction: TextInputAction.next,
                      focusNode: focus,
                      maxLength: 200,
                    ),
                  ),
                  Container(
                    child: defaultTextFormField(
                      context: context,
                      key: '2',
                      keyboardType: TextInputType.multiline,
                      textEditingController: _detail,
                      hintText: "details".tr().toString(),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      onChanged: (_) => setState(() {}),
                      maxLength: 20000,
                    ),
                  ),
                  Container(
                    child: defaultDropdownButton(
                        context: context,
                        list: titlesList,
                        value: _postType==null?titlesList[0]:_postType,
                        onChanged: (value) {
                          _postType = value;
                        },
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        }),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Container(
                    child: defaultBorderContainer(
                        child: Stack(
                      children: [
                        PhotoViewer(
                          enableInfiniteScroll: false,
                          images: _image==null?_image:[],
                          onDismissed: (_) {},
                          onPressed: () async {
                            _image?.clear();
                            await selectFiles(allowMultiple: false)
                                ?.then((value) => setState(() {
                                      _image?.insert(0, value?.firstOrNull);
                                    }));
                          },
                          icon: Icons.add_photo_alternate_outlined,
                        ),
                        // Container(
                        //   width: double.infinity,
                        //   child: InkWell(
                        //     onTap: () {
                        //       FocusScope.of(context).unfocus();
                        //       selectFiles(allowMultiple: false)
                        //           ?.then((value) => setState(() {
                        //                 _image = value?.firstOrNull;
                        //               }));
                        //     },
                        //     child: Container(
                        //       height: 215,
                        //       child: _image == null
                        //           ? _imageUrl == null
                        //               ? Icon(Icons.add_photo_alternate_outlined)
                        //               : ClipRRect(
                        //                   borderRadius:
                        //                       BorderRadius.circular(borderRadius),
                        //                   child: Image.network(
                        //                     _imageUrl!,
                        //                     fit: BoxFit.fill,
                        //                   ),
                        //                 )
                        //           : ClipRRect(
                        //               borderRadius: BorderRadius.circular(borderRadius),
                        //               child: Image.file(
                        //                 _image!,
                        //                 fit: BoxFit.fill,
                        //               ),
                        //             ),
                        //     ),
                        //   ),
                        // ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(borderRadius),
                                    bottomRight:
                                        Radius.circular(borderRadius))),
                            child: Text(
                              "titlePicture".tr().toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    )),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Container(
                    child: defaultBorderContainer(
                      child: Stack(
                        children: [
                          PhotoViewer(
                            enableInfiniteScroll: false,
                            images: _images,
                            onDismissed: (_) {},
                            onPressed: () async {
                              _images?.clear();
                              _images = await selectFiles();
                              setState(() {});
                            },
                            icon: Icons.add_to_photos_outlined,
                          ),
                          Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(borderRadius),
                                      bottomRight:
                                          Radius.circular(borderRadius))),
                              child: Text(
                                "extraPictures".tr().toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Container(
                    child: defaultElevatedButton(
                      onPressed: _submit,
                      child: Text(
                       isNew? 'post'.tr().toString():'edit'.tr().toString(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
