

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as dio;
import '../constant/api_constants.dart';
import '../database/dio/dio/dio_client.dart';
import '../models/support_Model.dart';

class SupportController extends GetxController{
  final DioClient dioClient;

  SupportController({required this.dioClient});

  ///Variables
  final isLoading = false.obs;
  final tickets = <Ticket>[].obs;
  final ticketStatusCount = <String, int>{}.obs;
  final ticketStatuses = <TicketStatus>[].obs;
  final ticketDepartments = <TicketDepartment>[].obs;
  final ticketReplies = <TicketReply>[].obs;

/// GET TICKET LIST--------------
  Future<void> getTicketsList() async {
    isLoading.value = true;
    try {
      final response = await dioClient.post(ApiConst.tickets);
      print("support response data---------");
      print(response.data);
      if (response.statusCode == 200 && response.data['status'] == 1) {
        final ticketModel = SupportTicketModel.fromJson(response.data);
        tickets.assignAll(ticketModel.data.ticketList);
        ticketStatusCount.assignAll(
            ticketModel.data.ticketStatus.map((key, value) =>
                MapEntry(key.toString(), value)));
        ticketStatuses.assignAll(ticketModel.data.status);
        ticketDepartments.assignAll(ticketModel.data.department);
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to fetch KYC details',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }


  /// GET TICKET DETAILS
  Future<void> getTicketDetails(String ticketId) async {
    isLoading.value = true;
    try {
      final response = await dioClient.post(
        ApiConst.ticketDetails,
        data: {"ticket_id": ticketId},
      );
      if (response.statusCode == 200 && response.data['status'] == 1) {
        final List repliesJson = response.data['data']['ticket_replies'] ?? [];
        ticketReplies.assignAll(repliesJson.map((e) => TicketReply.fromJson(e)).toList());
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to fetch ticket details',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  ///SENT MESSAGE-------------

  Future<void> sentMessage({required String ticketId, required String message}) async {
    isLoading.value = true;
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'ticket_id': ticketId,
        'message': message,
      });
      final response = await dioClient.post(
        ApiConst.ticketReplay,
        data: formData,
      );
      if (response.statusCode == 200 && response.data['status'] == 1) {
        await getTicketDetails(ticketId);
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to fetch ticket details',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  ///CREATE TICKET
  Future<void> createTicket({
    required String subject,
    required String departmentId,
    required String priorityId,
    required String message,
  }) async {
    isLoading.value = true;
    try {
      final formData = dio.FormData.fromMap({
        'subject': subject,
        'department': departmentId,
        'priority': priorityId,
        'message': message,
      });

      print(formData.fields);
      final response = await dioClient.post(ApiConst.createTicket, data: formData);

      if (response.statusCode == 200 && response.data['status'] == 1) {
        Get.back();
        await getTicketsList();
        Get.snackbar(
          'Success',
          'Ticket created successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to create ticket',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }



  /// STATUS  FILTER
  String? getStatusName(String? statusId) {
    return ticketStatuses.firstWhereOrNull((status) => status.ticketStatusId == statusId)?.name;
  }

  ///DEPARTMENT FILTER
  String? getDepartmentName(String? departmentId) {
    return ticketDepartments.firstWhereOrNull((dept) => dept.departmentId == departmentId)?.name;
  }

  ///FORMAT TIME
  String formatDateTime(String? input) {
    if (input == null || input.isEmpty || input == '-') {
      return '-';
    }

    try {
      final dateTime = DateTime.parse(input);
      return DateFormat.yMMMd().add_jm().format(dateTime);
    } catch (e) {
      // Log error and return fallback
      print("Error parsing date: $e");
      return '-';
    }
  }


  String getPriorityName(String? priorityId) {
    switch (priorityId) {
      case '1':
        return 'Low';
      case '2':
        return 'Medium';
      case '3':
        return 'High';
      default:
        return 'Unknown';
    }
  }

}