import 'package:flutter/material.dart';
import 'package:fx_crm/controller/support_controller.dart';
import 'package:fx_crm/view/component/drawer_component/component/support/create_support_ticket.dart';
import 'package:get/get.dart';

import '../../../../../main.dart';
import '../../../../../widgets/bg_container.dart';
import '../../../../../widgets/glass_card.dart';
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
    supportController = Get.put(SupportController(dioClient: dioClient));
    supportController.getTicketsList();
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
              backgroundColor: Colors.transparent,
              builder: (context) => const CreateSupportTicket(),
            );
          },
          label: const Text('Open Ticket', style: TextStyle(color: Colors.white)),
          icon: const Icon(Icons.add, color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(() {
            if (supportController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatusBox('1', 'Open', Colors.red),
                        _buildStatusBox('0', 'In Progress', Colors.green),
                        _buildStatusBox('0', 'Answered', Colors.blue),
                        _buildStatusBox('0', 'On Hold', Colors.orange),
                        _buildStatusBox('0', 'Closed', Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: supportController.tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = supportController.tickets[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(ticketId: ticket.ticketId),
                            ),
                          );
                        },
                        child: GlassCard(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Subject
                              Text(
                                ticket.subject,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Ticket Info (2 columns)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Left Column
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildDetail('Ticket ID', "#${ticket.ticketId}"),
                                        _buildDetail(
                                          'Department',
                                          supportController.getDepartmentName(ticket.department).toString(),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 24),

                                  // Right Column
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        _buildDetail(
                                          'Priority',
                                          supportController.getPriorityName(ticket.priority),
                                          color: _getPriorityColor(ticket.priority),
                                          alignRight: true,
                                        ),
                                        _buildDetail(
                                          'Status',
                                          supportController.getStatusName(ticket.status).toString(),
                                          color: _getStatusColor(ticket.status),
                                          alignRight: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Last Reply Info
                              _buildDetail(
                                'Last Reply',
                                supportController.formatDateTime(ticket.lastReply ?? '-'),
                              ),
                            ],
                          ),
                        ),

                      );
                    },
                  ),
                ),
              ],
            );
          }),
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
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 14, color: color)),
      ],
    );
  }

  Widget _buildDetail(String label, String value,
      {Color? color, bool alignRight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$label: ',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              TextSpan(
                text: value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color ?? Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.red;
      case 'in progress':
        return Colors.green;
      case 'answered':
        return Colors.blue;
      case 'on hold':
        return Colors.orange;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.white;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.redAccent;
      case 'medium':
        return Colors.amber;
      case 'low':
        return Colors.green;
      default:
        return Colors.white;
    }
  }
}
