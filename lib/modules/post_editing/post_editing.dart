import 'dart:io';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:newsapplication/layout/main_layout/main_layout.dart';
import 'package:newsapplication/models/post/posts_manager.dart';
import 'package:newsapplication/models/title/news_title.dart';
import 'package:newsapplication/models/title/news_titles_manager.dart';
import 'package:newsapplication/shared/components/components.dart';
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
  NewsTitle? _postTpe;
  final focus = FocusNode();
  File? _image;
  List<File>? _images;
  List<String>? _imagesUrl;
  String? _imageUrl = null;

  Future<void> _submit(BuildContext context) async {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List<NewsTitle> titlesList =
        Provider.of<NewsTitlesManager>(context, listen: true).titlesList;
    return defaultScaffld(
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
                        value: titlesList[0],
                        onChanged: (value) {
                          _postTpe = value;
                        }),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Container(
                    child: defaultImageButton(
                        child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          child: InkWell(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              selectFiles(allowMultiple: false)
                                  ?.then((value) => setState(() {
                                        _image = value?.firstOrNull;
                                      }));
                            },
                            child: Container(
                              height: size.height * 0.25,
                              child: _image == null
                                  ? _imageUrl == null
                                      ? Icon(Icons.add_photo_alternate_outlined)
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            _imageUrl!,
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        _image!,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
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
                    child: defaultImageButton(
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              child: Text(
                                "extraPictures".tr().toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          GridView.count(
                            crossAxisCount: 3,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            children: [
                              Container(
                                child: IconButton(
                                  onPressed: () async {
                                    _images = await selectFiles();
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.photo_library_sharp),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // PhotoViewer(images: _images, onDismissed: (_) {}),
                  PhotoViewer(images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png',
                  'http://www.w3bai.com/css/img_forest.jpg'], onDismissed: (_) {}),
                ],
              ),
            ),
          ),
        ));
  }
}
