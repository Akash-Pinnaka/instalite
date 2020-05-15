import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Container CircularProgress() {
  return Container(
    alignment: Alignment.center,
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
    ),
  );
}

// ignore: non_constant_identifier_names
Container LinearProgress() {
  return Container(
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
    ),
  );
}
