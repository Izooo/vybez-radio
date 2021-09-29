import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final appTheme = ThemeData.dark().copyWith(
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    elevation: 0,
  ),
);
