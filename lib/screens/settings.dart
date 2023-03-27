import 'package:club_app_frontend/utils.dart';
import 'package:flutter/material.dart';
import '../components/Header.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List notificationSettingsTitle = [
    "Mobile push notifications",
    "Email notifications"
  ];
  List notificationSettingsSubtitle = [
    "Receive push notifications on important updates and announcements via your mobile app.",
    "Receive emails on important updates and announcements."
  ];
  List notificationSettingsBooleans = [false, false];

  List settingsTitle = ["Password", "Appearance"];
  List settingsSubtitle = [
    "Change your password.",
    "Customize how $appName looks on your device."
  ];
  List settingsBooleans = [false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: nav("Settings"),
        drawer: sidebar(context),
        body: Container(
            margin: EdgeInsets.all(15),
            child: Column(children: [
              const SizedBox(height: 15),
              notificationSettings(),
              const SizedBox(height: 25),
              settings()
            ])));
  }

  Widget notificationSettings() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Notifications",
            style: h3,
          ),
        ),
        const SizedBox(height: 5),
        Divider(color: Colors.grey[300], height: 10),
        Column(
            children: List.generate(
          notificationSettingsTitle.length,
          (index) => Container(
            margin: EdgeInsets.only(bottom: 5),
            child: ListTile(
              title: Text(notificationSettingsTitle[index]),
              subtitle: Text(notificationSettingsSubtitle[index]),
              trailing: Switch(
                value: notificationSettingsBooleans[index],
                activeColor: Colors.blue[400],
                onChanged: (value) {
                  setState(() {
                    notificationSettingsBooleans[index] = value;
                  });
                },
              ),
            ),
          ),
        )),
      ],
    );
  }

  Widget settings() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Settings",
            style: h3,
          ),
        ),
        const SizedBox(height: 5),
        Divider(color: Colors.grey[300], height: 10),
        Column(
            children: List.generate(
          notificationSettingsTitle.length,
          (index) => Container(
            margin: EdgeInsets.only(bottom: 5),
            child: ListTile(
              title: Text(settingsTitle[index]),
              subtitle: Text(settingsSubtitle[index]),
              trailing: Switch(
                value: settingsBooleans[index],
                activeColor: Colors.blue[400],
                onChanged: (value) {
                  setState(() {
                    settingsBooleans[index] = value;
                  });
                },
              ),
            ),
          ),
        )),
      ],
    );
  }
}
