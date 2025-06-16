import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controller/support_controller.dart';
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
      initialChildSize: 0.55,
      maxChildSize: 0.9,
      minChildSize: 0.4,

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Create Ticket",style: TextStyle(
                      fontWeight: FontWeight.bold,fontSize: 18,letterSpacing: 2
                    ),),
                    IconButton(onPressed: () {
                      Get.back();
                    }, icon: Icon(Icons.close,color: Colors.black54,)),
                  ],
                ),
                SizedBox(height: 20,),
                CustomTextFormField(
                  label: 'Subject',
                  hint: 'Enter your subject',
                  labelColor: Colors.black,
                  enabledBorder: Colors.black54,
                  controller: subjectController,
                  textStyle: TextStyle(color: Colors.black54),
                  focusedBorder: Colors.black,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [

                    Expanded(
                      child:  DropDownTextFormField(
                        key: _departmentKey,
                        label: 'Department',
                        hint:  'Support',
                        style: TextStyle(color: Colors.black),
                        controller: departmentController,
                        readOnly: false,
                        onTap: _selectDepartment,
                        enabledBorder: Colors.black54,
                        fieldStyle: TextStyle(color: Colors.black),
                        colors: Colors.black54,
                        dropdownDisableColor: Colors.black26,
                        dropdownEnableColor: Colors.black87,
                        textStyle: TextStyle(color: Colors.black54),
                        focusedBorder: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child:  DropDownTextFormField(
                        key: _priorityKey,
                        style: TextStyle(color: Colors.black),
                        label: 'Priority',
                        hint:  'Select priority',
                        controller:  priorityController,
                        readOnly: false,
                        onTap: _selectPriorityType,
                        enabledBorder: Colors.black54,
                        textStyle: TextStyle(color: Colors.black54),
                        focusedBorder: Colors.black,
                          fieldStyle: TextStyle(color: Colors.black),
                          colors: Colors.black54,
                        dropdownEnableColor: Colors.black87,
                          dropdownDisableColor: Colors.black26,
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
                  enabledBorder: Colors.black54,
                  focusedBorder: Colors.black,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final subject = subjectController.text.trim();
                      final departmentName = departmentController.text.trim();
                      final priorityName = priorityController.text.trim();
                      final body = bodyController.text.trim();

                      if (subject.isEmpty || departmentName.isEmpty || priorityName.isEmpty || body.isEmpty) {
                        Get.snackbar('Error', 'Please fill all fields',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white);
                        return;
                      }

                      final SupportController controller = Get.find<SupportController>();

                      // Get department ID and priority ID from names
                      final departmentId = controller.ticketDepartments
                          .firstWhereOrNull((e) => e.name == departmentName)?.departmentId;
                      final priorityId = {
                        'Low': '1',
                        'Medium': '2',
                        'High': '3',
                      }[priorityName];

                      if (departmentId == null || priorityId == null) {
                        Get.snackbar('Error', 'Invalid department or priority selected',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white);
                        return;
                      }

                      await controller.createTicket(
                        subject: subject,
                        departmentId: departmentId,
                        priorityId: priorityId,
                        message: body,
                      );
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
