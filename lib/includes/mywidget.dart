import 'package:flutter/material.dart';

Widget waitProgress() {
  return Center(
    child: Container(
      width: 50,
      height: 50,
      child: CircularProgressIndicator(),
    ),
  );
}


String commaSprtr(String strNumber) {
  String tmptext = strNumber.replaceAll(",", "");
  String newtext = '';

  int j = 0;
  for (var i = tmptext.length - 1; i >= 0; i--) {
    j++;

    newtext = tmptext.substring(i, i + 1) + newtext;
    if (j == 3 && i > 0) {
      newtext = ',' + newtext;
      j = 0;
    }
//    print("$i $j $newtext");
  }

  return newtext;
}

