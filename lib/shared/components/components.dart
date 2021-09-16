import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:newsapplication/models/title/news_title.dart';
import 'package:photo_view/photo_view.dart';

Future<List<File>?>? selectFiles({bool allowMultiple = true}) async {
  List<File>? _files = [];
  try {
    final files = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (files == null) return _files;
    files.files.forEach((element) {
      _files.add(File(element.path));
    });
    return _files;
  } catch (e) {
    print(e);
  }
}

Image defaultImageLogo({fit}) => Image.asset(
      'assets/images/logo.png',
      fit: fit,
    );

defaultTextButton({required Function onPressed, required Widget child}) =>
    Builder(builder: (context) {
      return TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        onPressed: () {
          onPressed();
        },
        child: child,
      );
    });

defaultItemListView({required Column child, required Function() onPressed}) =>
    Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
      child: defaultTextButton(
        onPressed: () {
          onPressed();
        },
        child: Container(
          child: child,
        ),
      ),
    );

defaultImage({required String imageUrl}) => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: FadeInImage(
          imageErrorBuilder: (context, error, stackTrace) => Container(),
          image: NetworkImage(imageUrl),
          width: 120,
          height: 120,
          fit: BoxFit.fill,
          placeholder: AssetImage('assets/images/logo.png'),
        ),
      ),
    );

TextStyle textStyle(
        {double fontSize = 15,
        FontWeight fontWeight = FontWeight.bold,
        String fontFamily = "Cairo",
        Color color = Colors.black}) =>
    TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        color: color);

Widget defaultFloatingActionButton(
        {required IconData icon, required Function onPressed}) =>
    Builder(builder: (context) {
      return FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => onPressed(),
        child: Icon(
          icon,
          color: Theme.of(context).backgroundColor,
        ),
      );
    });

Widget defaultTextFormField({
  required TextEditingController textEditingController,
  required BuildContext context,
  FocusNode? focusNode,
  ValueChanged<String>? onFieldSubmitted,
  FormFieldValidator<String>? validator,
  FormFieldSetter<String>? onSaved,
  ValueChanged<String>? onChanged,
  TextInputType keyboardType = TextInputType.text,
  String hintText = "",
  int maxLength = 8000,
  TextInputAction? textInputAction,
}) =>
    Directionality(
      textDirection:
          intl.Bidi.detectRtlDirectionality(textEditingController.text)
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: TextFormField(
        controller: textEditingController,
        focusNode: focusNode,
        key: ValueKey('title'),
        validator: validator,
        onSaved: onSaved,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        keyboardType: keyboardType,
        maxLength: maxLength,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          hintText: hintText,
          hintTextDirection: Directionality.of(context),
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          hintStyle: Theme.of(context).textTheme.headline4,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );

Widget defaultDropdownButton({
  required BuildContext context,
  IconData icon = Icons.arrow_drop_down_circle_sharp,
  required List<NewsTitle> list,
  required value,
  Widget? hint,
  VoidCallback? onTap,
  required onChanged,
  FormFieldSetter? onSaved,
}) =>
    DropdownButtonFormField(
      isDense: false,
      icon: Icon(
        icon,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide()),
      ),
      value: value,
      hint: hint,
      isExpanded: true,
      onTap: onTap,
      onChanged: onChanged,
      onSaved: onSaved,
      items: list.map((val) {
        return DropdownMenuItem(
            value: val,
            child: Container(
              child: Text(val.title),
            ));
      }).toList(),
    );

Widget defaultImageButton({required child}) => Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );

Widget defaultPhotoView(
        {required File value,
        required Function onPressed,
        disableGestures = true}) =>
    PhotoView(
      onTapDown: (context, details, controllerValue) {
        onPressed();
      },
      disableGestures: disableGestures,
      imageProvider: FileImage(value),
      initialScale: disableGestures
          ? PhotoViewComputedScale.covered
          : PhotoViewComputedScale.contained,
      errorBuilder: (context, error, stackTrace) => Center(
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              primary: Colors.white.withOpacity(0.5),
              minimumSize: Size(50, 50)),
          child: const Icon(
            Icons.refresh,
            color: Colors.black,
          ),
        ),
      ),
      loadingBuilder: (context, event) => Center(
        child: SizedBox(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
          ),
        ),
      ),
    );

Future<dynamic> defaultDialog(
    {required BuildContext context, id, Widget? title, Widget? child}) async {
  AlertDialog alertDialog = AlertDialog(
    backgroundColor: Theme.of(context).primaryColor,
    title: title,
    content: Container(
      height: 90,
      child: child,
    ),
  );
  return await showDialog(context: context, builder: (context) => alertDialog);
}

Future<dynamic> defaultConfirmDialog({
  required BuildContext context,
}) =>
    defaultDialog(
        context: context,
        child: Column(
          children: [
            Text(
              "doYouWantToDeleteThePost".tr().toString(),
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      "yes".tr().toString(),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      "no".tr().toString(),
                    )),
              ],
            )
          ],
        ));
