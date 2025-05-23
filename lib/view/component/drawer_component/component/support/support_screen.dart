import 'package:flutter/material.dart';
import 'package:fx_crm/controller/support_controller.dart';
import 'package:fx_crm/view/component/drawer_component/component/support/create_support_ticket.dart';
import 'package:get/get.dart';

import '../../../../../main.dart';
import '../../../../../widgets/bg_container.dart';
import 'support_chat.dart';

class SupportPage extends StatefulWidget {


  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {

  late final SupportController supportController;
  @override
  void initState() {
    super.initState();
    supportController = Get.put(
      SupportController(dioClient: dioClient),
    ); // Provide dioClient
    supportController. getTicketsList();
  }
  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Support',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.lightBlue,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              isDismissible: true,
              backgroundColor: Colors.transparent,
              builder: (context) => CreateSupportTicket(),
            );
          },
          label: Text('Open Ticket',style: TextStyle(color: Colors.white),),
          icon: Icon(Icons.add,color:Colors.white),

        ),
        body: Obx(() {
          if (supportController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatusBox('1', 'Open', Colors.red),
                      _buildStatusBox('0', 'In progress', Colors.green),
                      _buildStatusBox('0', 'Answered', Colors.blue),
                      _buildStatusBox('0', 'On Hold', Colors.orange),
                      _buildStatusBox('0', 'Closed', Colors.grey),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: supportController.tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = supportController.tickets[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to chat page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(ticketId: ticket.ticketId),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ticket.subject,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 6),

                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _buildDetail('Ticket ID',
                                                "#${ticket.ticketId}"),
                                            _buildDetail(
                                              'Department',
                                              supportController.getDepartmentName(ticket.department),
                                            ),
                                            // _buildDetail('Project', ticket.userId),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 30,),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            _buildDetail('Priority', supportController.getPriorityName(ticket.priority), alignRight: true),
                                            _buildDetail('Status', supportController.getStatusName(ticket.status), alignRight: true),

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  _buildDetail('Last Reply', supportController.formatDateTime(ticket.lastReply ?? '-')),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  Widget _buildStatusBox(String count, String label, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 14, color: color)),
      ],
    );
  }

  Widget _buildDetail(String label, String? value,{bool alignRight = false}) {
    Color? textColor;
    if (label == 'Status') {
      switch (value?.toLowerCase()) {
        case 'open':
          textColor = Colors.red;
          break;
        case 'in progress':
          textColor = Colors.green;
          break;
        case 'answered':
          textColor = Colors.blue;
          break;
        case 'on hold':
          textColor = Colors.orange;
          break;
        case 'closed':
          textColor = Colors.grey;
          break;
        default:
          textColor = Colors.white;
      }
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
        alignRight ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Flexible(
            child: Text(
              value ?? '-',
              style: TextStyle(color: textColor ?? Colors.black87, fontWeight: label == 'Status' ? FontWeight.bold : null,),
              textAlign: alignRight ? TextAlign.end : TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
