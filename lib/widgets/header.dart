import 'package:flutter/material.dart';

AppBar header(BuildContext context, {bool isTitle, String dispTitle}) {
  return AppBar(
    title: Text(
      isTitle ? "Insta Lite" : dispTitle,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isTitle ? "Signatra" : '',
        fontSize: isTitle ? 55 : 22,
      ),
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
