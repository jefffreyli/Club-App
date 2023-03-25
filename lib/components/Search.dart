import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _Search();
}

class _Search extends State<Search> {
  String search = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            labelText: 'Search a Club',
            suffixIcon: Icon(Icons.search),
          ),
          onChanged: (text) {
            setState(() => search = text.toLowerCase());
          },
        ),
      ],
    );
  }
}
