import 'package:flutter/material.dart';

Widget tag(String name) {
  return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Center(
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300],
              ),
              padding: const EdgeInsets.all(7.0),
              child: Text(name, style: TextStyle(color: Colors.grey[700])))));
}
