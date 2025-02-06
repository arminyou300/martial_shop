
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  void loadNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notifications = prefs.getStringList('notifications') ?? [];
    });
  }

  void saveNotification(String title, String body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String notification = '$title\n$body';
    if (!notifications.contains(notification)) {
      List<String> updatedList = [...notifications, notification];
      await prefs.setStringList('notifications', updatedList);
      setState(() {
        notifications = updatedList;
      });
    }
  }

  void clearNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('notifications'); // Update the key to 'notifications'
    setState(() {
      notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final RemoteMessage? message =
        ModalRoute.of(context)!.settings.arguments as RemoteMessage?;

    if (message != null) {
      saveNotification(
        message.notification?.title ?? "No Title",
        message.notification?.body ?? "No Body",
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: clearNotifications,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          notifications.isEmpty
              ? const Center(
                  child: Text('No notifications received.'),
                )
              : Expanded(
                  child: ListView.separated(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index].split('\n');
                      final title = notification[0];
                      final body =
                          notification.length > 1 ? notification[1] : '';
                      return Container(
                        width: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                body,
                                maxLines: 3, // Limit to 3 lines
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 20,
                        color: Colors.grey.shade100,
                        indent: 20,
                        endIndent: 20,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
