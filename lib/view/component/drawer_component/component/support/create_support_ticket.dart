import 'package:flutter/material.dart';

import '../../../../../widgets/bg_container.dart';
import '../../../../../widgets/custom_text_form.dart';
import '../../../../../widgets/drop_down_text_field.dart';


class CreateSupportTicket extends StatefulWidget {
  const CreateSupportTicket({super.key});

  @override
  State<CreateSupportTicket> createState() => _CreateSupportTicketState();
}

class _CreateSupportTicketState extends State<CreateSupportTicket> {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController departmentController = TextEditingController(text: 'Support');
  final TextEditingController priorityController = TextEditingController(text: 'Low');
  final TextEditingController bodyController = TextEditingController();

  @override
  void dispose() {
    subjectController.dispose();
    departmentController.dispose();
    priorityController.dispose();
    bodyController.dispose();
    super.dispose();
  }
  final GlobalKey _priorityKey = GlobalKey();
  final List<String> priorityOptions = ['Low', 'Medium', 'High'];
  final GlobalKey _departmentKey = GlobalKey();
  final List<String> departmentOptions = ['Support'];
  void _showDropdownMenu(GlobalKey key, List<String> options, TextEditingController controller) async {
    final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx + size.width,
        offset.dy,
      ),
      items: options.map((option) {
        return PopupMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
    );

    if (selected != null) {
      setState(() {
        controller.text = selected;
      });
    }
  }
  void _selectPriorityType() => _showDropdownMenu(_priorityKey, priorityOptions,   priorityController);
  void _selectDepartment() => _showDropdownMenu(_departmentKey, departmentOptions,   departmentController);
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      maxChildSize: 0.7,
      minChildSize: 0.2,

      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Create Ticket",style: TextStyle(
                  fontWeight: FontWeight.bold,fontSize: 18,letterSpacing: 2
                ),),
                CustomTextFormField(
                  label: 'Subject',
                  hint: 'Enter subject',
                  controller: subjectController,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [

                    Expanded(
                      child:  DropDownTextFormField(
                        key: _departmentKey,
                        label: 'Department',
                        hint:  'Support',
                        controller: departmentController,
                        readOnly: false,
                        onTap: _selectDepartment,
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child:  DropDownTextFormField(
                        key: _priorityKey,
                        label: 'Priority',
                        hint:  'Select priority',
                        controller:  priorityController,
                        readOnly: false,
                        onTap: _selectPriorityType,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  label: 'Ticket Body',
                  labelColor: Colors.black,
                  textStyle: TextStyle(color: Colors.black54),
                  hint: 'Describe your issue',
                  controller: bodyController,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Save profile changes
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Create',
                        style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                )

              ],
            ),
          ),
        );
      },
    );
  }
}
