import 'package:flutter/material.dart';

class SectionTab extends StatefulWidget {
  final String tabIcon;
  final String tabName;
  const SectionTab({super.key, required this.tabName, required this.tabIcon});
  @override
  State<SectionTab> createState() => _SectionTabState();
}

class _SectionTabState extends State<SectionTab> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (() {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => Section(
          //             sectionName: widget.tabName,
          //             sectionIcon: widget.tabIcon,
          //             sectionBG: widget.tabBG)));
        }),
        child: Column(children: [
          Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              elevation: 3,
              child: Center(
                  child: Container(
                padding: const EdgeInsets.all(10),
                child: CircleAvatar(
                    radius: 30, backgroundImage: AssetImage(widget.tabIcon)),
              ))),
          const SizedBox(height: 8),
          Text(widget.tabName,
              maxLines: 1,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis))
        ]));
  }
}
