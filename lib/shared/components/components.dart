import 'package:flutter/material.dart';

Image defaultImageLogo({fit}) => Image.asset(
      'assets/images/logo.png',
      fit: fit,
    );

defaultTextButton({required Function onPressed, required Widget child}) =>
    TextButton(
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

defaultImage({required String imageUrl})=>Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(10.0),
    child: FadeInImage(
      imageErrorBuilder:
          (context, error, stackTrace) =>
          Container(),
      image: NetworkImage(imageUrl),
      width: 120,
      height: 120,
      fit: BoxFit.fill,
      placeholder:
      AssetImage('assets/images/logo.png'),
    ),
  ),
);