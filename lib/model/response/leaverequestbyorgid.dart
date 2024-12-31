class LeaveModel {
  final String id;
  final String orgId;
  final String userId;
  final String leaveTypeId;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final int noOfDays;
  final String leaveDuration;
  final String attachment;
  final String status;
  final DateTime createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;

  LeaveModel({
    required this.id,
    required this.orgId,
    required this.userId,
    required this.leaveTypeId,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.noOfDays,
    required this.leaveDuration,
    required this.attachment,
    required this.status,
    required this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json['id'],
      orgId: json['orgid'],
      userId: json['userid'],
      leaveTypeId: json['leave_type_id'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      reason: json['reason'],
      noOfDays: json['no_of_days'],
      leaveDuration: json['leave_duration'],
      attachment: json['attachment'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdat']),
      createdBy: json['createdby'],
      updatedAt: json['updatedat'] != null ? DateTime.parse(json['updatedat']) : null,
      updatedBy: json['updatedby'],
    );
  }
}
