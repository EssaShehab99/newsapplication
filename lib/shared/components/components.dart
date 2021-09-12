import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:newsapplication/models/title/news_title.dart';

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
        onPressed: () => onPressed,
        child: child,
      );
    });

defaultItemListView({required Column child}) => Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
      child: defaultTextButton(
        onPressed: () {},
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

