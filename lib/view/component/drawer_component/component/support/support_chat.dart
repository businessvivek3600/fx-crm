import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controller/support_controller.dart';
import '../../../../../widgets/bg_container.dart';


class ChatPage extends StatefulWidget {
  final String ticketId;
  ChatPage({required this.ticketId, Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final supportController = Get.find<SupportController>();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      supportController.getTicketDetails(widget.ticketId);
    });
  }


  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Chat - ${widget.ticketId}',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: Obx(() {
          return Column(
            children: [
              if (supportController.isLoading.value)
                Center(child: CircularProgressIndicator())
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: supportController.ticketReplies.length,
                    itemBuilder: (context, index) {
                      final reply = supportController.ticketReplies[index];
                      final isSentByUser = reply.admin == null; // user = null admin
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: isSentByUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: isSentByUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSentByUser ? Colors.blue : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  reply.message ?? '',
                                  style: TextStyle(
                                      color: isSentByUser ? Colors.white : Colors.black87),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                reply.date != null
                                    ? supportController.formatDateTime(reply.date!) ?? ''
                                    : '',
                                style: TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        // Add send logic if needed
                        _controller.clear();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
            ],
          );
        }),
      ),
    );
  }
}
