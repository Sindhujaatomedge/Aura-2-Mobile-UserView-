class LeaveModel {
  final String? id;
  final String? orgId;
  final String? userId;
  final String? username;
  final String? avatar;
  final String? leaveTypeId;
  final String? leaveType;
  final String? icon;
  final String? colorCode;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? reason;
  final double? noOfDays;
  final String? leaveDuration;
  final String? attachment;
  final String? status;
  final DateTime? createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;
  final String? behalfOf;

  LeaveModel({
    required this.id,
    required this.orgId,
    required this.userId,
    required this.username,
    required this.avatar,
    required this.leaveTypeId,
    required this.leaveType,
    required this.icon,
    required this.colorCode,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.noOfDays,
    required this.leaveDuration,
    required this.attachment,
    required this.status,
    required this.createdAt,
    required this.createdBy,
    this.updatedAt,
    required this.updatedBy,
    this.behalfOf,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json['id'] ?? '',
      orgId: json['orgid'] ?? '',
      userId: json['userid'] ?? '',
      username: json['username'] ?? '',
      avatar: json['avatar'] ?? '',
      leaveTypeId: json['leave_type_id'] ?? '',
      leaveType: json['leavetype'] ?? '',
      icon: json['icon'] ?? '',
      colorCode: json['colorcode'] ?? '',
      startDate: DateTime.parse(json['start_date']??''),
      endDate: DateTime.parse(json['end_date'] ?? ''),
      reason: json['reason'] ?? '',
      noOfDays: json['no_of_days'].toDouble() ?? '',
      leaveDuration: json['leave_duration'] ?? '',
      attachment: json['attachment'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdat'] ?? '') ,
      createdBy: json['createdby'] ?? '',
      updatedAt: json['updatedat'] != null ? DateTime.parse(json['updatedat']) : null,
      updatedBy: json['updatedby'] ?? '',
      behalfOf: json['behlafof'] ?? '',
    );
  }


}