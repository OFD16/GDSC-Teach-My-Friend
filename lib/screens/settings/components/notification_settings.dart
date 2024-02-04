import 'package:Sharey/local_storage/auth_storage.dart';
import 'package:flutter/material.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  AuthStorage authStorage = AuthStorage();
  bool pushNotifications = false, emailNotifications = false;

  void getNotificationSettings() async {
    bool pushNotificationsEnabled =
        await authStorage.pushNotificationsEnabled();
    bool emailNotificationsEnabled =
        await authStorage.emailNotificationsEnabled();
    setState(() {
      pushNotifications = pushNotificationsEnabled;
      emailNotifications = emailNotificationsEnabled;
    });
  }

  @override
  void initState() {
    super.initState();
    getNotificationSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Notification Settings",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ListTile(
          title: const Text("Push Notifications"),
          trailing: Switch(
            value: pushNotifications,
            onChanged: (value) {
              setState(() {
                pushNotifications = value;
                authStorage.setPushNotificationsEnabled(value);
              });
            },
          ),
        ),
        ListTile(
          title: const Text("Email Notifications"),
          trailing: Switch(
            value: emailNotifications,
            onChanged: (value) {
              setState(() {
                emailNotifications = value;
                authStorage.setEmailNotificationsEnabled(value);
              });
            },
          ),
        ),
      ],
    );
  }
}
