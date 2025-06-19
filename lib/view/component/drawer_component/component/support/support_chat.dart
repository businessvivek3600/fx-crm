import 'package:flutter/material.dart';
import 'package:fx_crm/widgets/glass_card.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../controller/support_controller.dart';
import '../../../../../widgets/bg_container.dart';

class ChatPage extends StatefulWidget {
  final String ticketId;
  const ChatPage({required this.ticketId, super.key});

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
              Expanded(
                child: supportController.isLoading.value
                    ? ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: index % 2 == 0
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: GlassCard(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.6,


                              child: const Text(''),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
                    : ListView.builder(
                  itemCount: supportController.ticketReplies.length,
                  itemBuilder: (context, index) {
                    final reply = supportController.ticketReplies[index];
                    final isSentByUser = reply.admin == null;
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSentByUser
                                    ? Colors.blue
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(16),
                              ),

                              child: Text(
                                reply.message ?? '',
                                style: TextStyle(
                                  color: isSentByUser
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              reply.date != null
                                  ? supportController.formatDateTime(
                                reply.date!,
                              ) ??
                                  ''
                                  : '',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
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
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(255, 255, 255, 0.1),
                              Color.fromRGBO(255, 255, 255, 0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.white54,width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        final message = _controller.text.trim();
                        if (message.isNotEmpty) {
                          supportController.sentMessage(
                            ticketId: widget.ticketId,
                            message: message,
                          );
                          _controller.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
            ],
          );
        }),
      ),
    );
  }
}
