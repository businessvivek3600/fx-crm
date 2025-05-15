import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../database/notification_db.dart';
import '../../../widgets/bg_container.dart';


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
  return  BackgroundContainer(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              'Notifications',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await NotificationDatabase().clearNotifications();
                  _loadNotifications();
                },
              ),
            ],
            elevation: 0,
            centerTitle: true,
          ),
          body:
          notifications.isEmpty
          ? const Center(child: Text("No notifications found",style: TextStyle(color: Colors.white),))
          : Padding(
            padding: const EdgeInsets.all(12),
            child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
            final item = notifications[index];
            return Card(
              color: Colors.grey.shade700.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: item['image'] != null && item['image'] != ''
                    ? CircleAvatar(
                  backgroundImage: NetworkImage(item['image']),
                )
                    : const CircleAvatar(child: Icon(Icons.notifications)),
                title: Text(item['title'] ?? 'No Title',style: TextStyle(color: Colors.white),),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['body'] ?? 'No message',style: TextStyle(color: Colors.white70),),
                    const SizedBox(height: 4),
                    Text(
                      formatTimestamp(item['timestamp']),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                isThreeLine: true,
              ),
            );
                    },
                  ),
          ),
      ),
    );
  }
}
