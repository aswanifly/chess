import 'package:flutter/material.dart';

Widget verticalHeight({required double height}) {
  return SizedBox(height: height);
}

Widget horizontalWidth({required double width}) {
  return SizedBox(width: width);
}

const rowSpacer = TableRow(children: [
  SizedBox(
    height: 8,
  ),
  SizedBox(
    height: 8,
  )
]);
