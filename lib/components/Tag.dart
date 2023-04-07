import 'package:flutter/material.dart';

Widget tag(String name, Color colorFont, Color colorBackground) {
  return Container(
      // margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Center(
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: colorBackground,
              ),
              padding: const EdgeInsets.all(7.0),
              child: Text(name, style: TextStyle(color: colorFont)))));
}

Widget smallTag(String name, Color colorFont, Color colorBackground) {
  return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Center(
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: colorBackground,
              ),
              padding: const EdgeInsets.all(5.0),
              child: Text(name, style: TextStyle(fontSize: 10, color: colorFont)))));
}
