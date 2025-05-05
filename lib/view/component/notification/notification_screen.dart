import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../database/notification_db.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final data = await NotificationDatabase().getAllNotifications();
    setState(() {
      notifications = data;
    });
  }

  String formatTimestamp(String timestamp) {
    final dateTime = DateTime.tryParse(timestamp);
    return dateTime != null
        ? DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime)
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await NotificationDatabase().clearNotifications();
              _loadNotifications();
            },
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(child: Text("No notifications found"))
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return ListTile(
            leading: item['image'] != null && item['image'] != ''
                ? CircleAvatar(
              backgroundImage: NetworkImage(item['image']),
            )
                : const CircleAvatar(child: Icon(Icons.notifications)),
            title: Text(item['title'] ?? 'No Title'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['body'] ?? 'No message'),
                const SizedBox(height: 4),
                Text(
                  formatTimestamp(item['timestamp']),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            isThreeLine: true,
          );
        },
      ),
    );
  }
}
