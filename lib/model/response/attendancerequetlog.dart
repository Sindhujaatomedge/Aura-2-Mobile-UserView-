class AttendanceRequestLog {
  final String id;
  final String name;
  final String userid;
  final String avatar;
  final String checkindate;
  final String checkintime;
  final String checkoutdate;
  final String checkouttime;
  final String checkoutmedium;
  final String hours;
  final String? comments;
  final String status;
  final String approver_type;

  AttendanceRequestLog(
      {
        required this.id,
        required this.name,
        required this.userid,
        required this.checkindate,
        required this.checkintime,
        required this.avatar,
        required this.approver_type,

        required this.checkoutdate,
        required this.checkouttime,
        required this.checkoutmedium,
        required this.hours,
        required this.comments,
        required this.status});

  factory AttendanceRequestLog.fromJson(Map<String, dynamic> json) {
    return AttendanceRequestLog(
      id: json['id'] ?? '',
      name :json['name'] ?? '',
      userid: json['userid'] ?? '',
      checkindate: json['checkindate'] ?? '',


      checkoutdate: json['checkoutdate'] ?? '',

      checkintime: json['checkintime'] ?? '',
      checkouttime: json['checkouttime'] ?? '',
      checkoutmedium: json['checkoutmedium'] ?? '',
      hours: json['hours'] ?? '',
      comments: json['comments'] ?? '',
      status: json['status'] ?? '',
      avatar: json['avatar'] ?? '',
      approver_type: json['approver_type'] ?? '',

    );
  }
}