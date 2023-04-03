import 'package:flutter/material.dart';

Widget personCardHorizontal(String name, String img) {
  return Container(
      padding: const EdgeInsets.all(5),
      child: Card(
          elevation: 3,
          child: ListTile(
            tileColor: Colors.grey[50],
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.asset(img)),
            title: Text(name),
          )));
}
