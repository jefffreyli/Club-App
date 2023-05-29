import 'package:flutter/material.dart';
import '../screens/profile.dart';
import '../utils.dart';
import '../screens/profile.dart';
import '../models/person.dart';

Widget personCardHorizontal(Person person, BuildContext context, bool editable,
    [String? position]) {
  return GestureDetector(
    onTap: () {
      navigate(
          context,
          Profile(person: person, editable: editable));
    },
    child: Container(
      margin: EdgeInsets.only(bottom: 3),
      child: Card(
          // color: Colors.grey[50],
          elevation: 1.5,
          child: Padding(
            padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
            child: ListTile(
              // tileColor: Colors.grey[50],
              leading: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(person.imageURL),
              ),
              title: Text(person.name),
              subtitle: position != null ? Text(position) : null,
            ),
          )),
    ),
  );
}
