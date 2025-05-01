class SupportTicketModel {
  final int status;
  final int isLogin;
  final SupportTicketData data;
  final String message;

  SupportTicketModel({
    required this.status,
    required this.isLogin,
    required this.data,
    required this.message,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      status: json['status'],
      isLogin: json['is_login'],
      data: SupportTicketData.fromJson(json['data']),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'is_login': isLogin,
      'data': data.toJson(),
      'message': message,
    };
  }
}

class SupportTicketData {
  final List<TicketStatus> status;
  final List<TicketDepartment> department;
  final int statusId;
  final List<Ticket> ticketList;
  final Map<String, int> ticketStatus;
  final String title;

  SupportTicketData({
    required this.status,
    required this.department,
    required this.statusId,
    required this.ticketList,
    required this.ticketStatus,
    required this.title,
  });

  factory SupportTicketData.fromJson(Map<String, dynamic> json) {
    return SupportTicketData(
      status: (json['status'] as List)
          .map((e) => TicketStatus.fromJson(e))
          .toList(),
      department: (json['department'] as List)
          .map((e) => TicketDepartment.fromJson(e))
          .toList(),
      statusId: json['status_id'],
      ticketList: (json['ticket_list'] as List)
          .map((e) => Ticket.fromJson(e))
          .toList(),
      ticketStatus: Map<String, int>.from(json['ticket_status']),
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.map((e) => e.toJson()).toList(),
      'department': department.map((e) => e.toJson()).toList(),
      'status_id': statusId,
      'ticket_list': ticketList.map((e) => e.toJson()).toList(),
      'ticket_status': ticketStatus,
      'title': title,
    };
  }
}

class TicketStatus {
  final String ticketStatusId;
  final String name;
  final String isDefault;
  final String statusColor;
  final String statusOrder;

  TicketStatus({
    required this.ticketStatusId,
    required this.name,
    required this.isDefault,
    required this.statusColor,
    required this.statusOrder,
  });

  factory TicketStatus.fromJson(Map<String, dynamic> json) {
    return TicketStatus(
      ticketStatusId: json['ticketstatusid'],
      name: json['name'],
      isDefault: json['isdefault'],
      statusColor: json['statuscolor'],
      statusOrder: json['statusorder'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketstatusid': ticketStatusId,
      'name': name,
      'isdefault': isDefault,
      'statuscolor': statusColor,
      'statusorder': statusOrder,
    };
  }
}

class TicketDepartment {
  final String departmentId;
  final String name;
  final String imapUsername;
  final String email;
  final String emailFromHeader;
  final String host;
  final String password;
  final String encryption;
  final String deleteAfterImport;
  final String calendarId;
  final String hideFromClient;

  TicketDepartment({
    required this.departmentId,
    required this.name,
    required this.imapUsername,
    required this.email,
    required this.emailFromHeader,
    required this.host,
    required this.password,
    required this.encryption,
    required this.deleteAfterImport,
    required this.calendarId,
    required this.hideFromClient,
  });

  factory TicketDepartment.fromJson(Map<String, dynamic> json) {
    return TicketDepartment(
      departmentId: json['departmentid'],
      name: json['name'],
      imapUsername: json['imap_username'],
      email: json['email'],
      emailFromHeader: json['email_from_header'],
      host: json['host'],
      password: json['password'],
      encryption: json['encryption'],
      deleteAfterImport: json['delete_after_import'],
      calendarId: json['calendar_id'],
      hideFromClient: json['hidefromclient'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'departmentid': departmentId,
      'name': name,
      'imap_username': imapUsername,
      'email': email,
      'email_from_header': emailFromHeader,
      'host': host,
      'password': password,
      'encryption': encryption,
      'delete_after_import': deleteAfterImport,
      'calendar_id': calendarId,
      'hidefromclient': hideFromClient,
    };
  }
}

class Ticket {
  final String ticketId;
  final String adminReplying;
  final String userId;
  final String contactId;
  final String? email;
  final String name;
  final String department;
  final String priority;
  final String status;
  final String? service;
  final String ticketKey;
  final String subject;
  final String message;
  final String? admin;
  final String date;
  final String projectId;
  final String? lastReply;
  final String clientRead;
  final String adminRead;
  final String ip;
  final String assigned;

  Ticket({
    required this.ticketId,
    required this.adminReplying,
    required this.userId,
    required this.contactId,
    this.email,
    required this.name,
    required this.department,
    required this.priority,
    required this.status,
    this.service,
    required this.ticketKey,
    required this.subject,
    required this.message,
    this.admin,
    required this.date,
    required this.projectId,
    this.lastReply,
    required this.clientRead,
    required this.adminRead,
    required this.ip,
    required this.assigned,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      ticketId: json['ticketid'],
      adminReplying: json['adminreplying'],
      userId: json['userid'],
      contactId: json['contactid'],
      email: json['email'],
      name: json['name'],
      department: json['department'],
      priority: json['priority'],
      status: json['status'],
      service: json['service'],
      ticketKey: json['ticketkey'],
      subject: json['subject'],
      message: json['message'],
      admin: json['admin'],
      date: json['date'],
      projectId: json['project_id'],
      lastReply: json['lastreply'],
      clientRead: json['clientread'],
      adminRead: json['adminread'],
      ip: json['ip'],
      assigned: json['assigned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketid': ticketId,
      'adminreplying': adminReplying,
      'userid': userId,
      'contactid': contactId,
      'email': email,
      'name': name,
      'department': department,
      'priority': priority,
      'status': status,
      'service': service,
      'ticketkey': ticketKey,
      'subject': subject,
      'message': message,
      'admin': admin,
      'date': date,
      'project_id': projectId,
      'lastreply': lastReply,
      'clientread': clientRead,
      'adminread': adminRead,
      'ip': ip,
      'assigned': assigned,
    };
  }
}

class TicketReply {
  final String? id;
  final String? ip;
  final String? fromName;
  final String? replyEmail;
  final String? admin;
  final String? userid;
  final String? message;
  final String? date;
  final String? contactid;
  final String? submitter;
  final List<dynamic>? attachments;

  TicketReply({
    this.id,
    this.ip,
    this.fromName,
    this.replyEmail,
    this.admin,
    this.userid,
    this.message,
    this.date,
    this.contactid,
    this.submitter,
    this.attachments,
  });

  factory TicketReply.fromJson(Map<String, dynamic> json) {
    return TicketReply(
      id: json['id'],
      ip: json['ip'],
      fromName: json['from_name'],
      replyEmail: json['reply_email'],
      admin: json['admin'],
      userid: json['userid'],
      message: json['message'],
      date: json['date'],
      contactid: json['contactid'],
      submitter: json['submitter'],
      attachments: json['attachments'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ip': ip,
      'from_name': fromName,
      'reply_email': replyEmail,
      'admin': admin,
      'userid': userid,
      'message': message,
      'date': date,
      'contactid': contactid,
      'submitter': submitter,
      'attachments': attachments,
    };
  }
}

