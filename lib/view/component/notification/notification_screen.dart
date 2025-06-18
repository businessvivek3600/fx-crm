import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controller/notification_controller.dart';
import '../../../database/notification_db.dart';
import '../../../widgets/bg_container.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationDatabase db = NotificationDatabase();

  @override
  void initState() {
    super.initState();
    db.getAllNotifications();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationDatabase().markAllAsRead();
      Get.find<NotificationController>().resetUnreadCount();
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
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Notifications',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: db.notificationStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final notifications = snapshot.data!;
            if (notifications.isEmpty) {
              return const Center(
                child: Text("No notifications found", style: TextStyle(color: Colors.white)),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(12),
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final item = notifications[index];
                  return Card(
                    color: Colors.grey.shade900.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: item['image'] != null && item['image'] != ''
                          ? CircleAvatar(backgroundImage: NetworkImage(item['image']))
                          : const CircleAvatar(child: Icon(Icons.notifications)),
                      trailing: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onSelected: (value) async {
                          if (value == 'open') {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(item['title'] ?? 'No Title'),
                                content: Text(item['body'] ?? 'No message'),
                              ),
                            );
                          } else if (value == 'delete') {
                            await db.deleteNotification(item['id']);
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'open', child: Text('Open')),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                      title: Text(item['title'] ?? 'No Title', style: const TextStyle(color: Colors.white)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['body'] ?? 'No message', style: const TextStyle(color: Colors.white70)),
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
            );
          },
        ),
      ),
    );
  }
}

