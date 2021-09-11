import 'package:flutter/material.dart';

Image defaultImageLogo({fit}) => Image.asset(
      'assets/images/logo.png',
      fit: fit,
    );

defaultTextButton({required Function onPressed, required Widget child}) =>
    Builder(
      builder: (context) {
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
      }
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
        {required IconData icon,
        required Function onPressed}) =>
    Builder(
      builder: (context) {
        return FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => onPressed(),
          child: Icon(icon,color: Theme.of(context).backgroundColor,),
        );
      }
    );
