import '../fb_helper.dart';
import '../utils.dart';
import 'package:flutter/material.dart';
import '../components/Nav.dart';

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

  List settingsTitle = ["Password", "Appearance"];

  List settingsSubtitle = [
    "Change your password.",
    "Customize how $appName looks on your device."
  ];

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
            children: notificationSettingsTitle.map((title) {
          return Container(
            margin: EdgeInsets.only(bottom: 5),
            child: ListTile(
              title: Text(title),
              subtitle: Text(notificationSettingsSubtitle[
                  notificationSettingsTitle.indexOf(title)]),
              trailing: Switch(
                value: userData[title == "Email notifications"
                        ? 'email_notifications'
                        : 'mobile_notifications'] ==
                    'true',
                activeColor: green_2,
                onChanged: (value) async {
                  if (title == "Email notifications") {
                    await updateSettings(emailNotifications: value.toString());
                  } else if (title == "Mobile push notifications") {
                    await updateSettings(mobileNotifications: value.toString());
                  }
                  setState(() {}); // Refresh UI
                },
              ),
            ),
          );
        }).toList()),
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
            children: settingsTitle.map((title) {
          return Container(
            margin: EdgeInsets.only(bottom: 5),
            child: ListTile(
              title: Text(title),
              subtitle: Text(settingsSubtitle[settingsTitle.indexOf(title)]),
              trailing: title == "Appearance"
                  ? Switch(
                      value: userData['appearance'] == 'true',
                      activeColor: green_2,
                      onChanged: (value) async {
                        await updateSettings(appearance: value.toString());
                        setState(() {}); // Refresh UI
                      },
                    )
                  : null,
            ),
          );
        }).toList()),
      ],
    );
  }
}
