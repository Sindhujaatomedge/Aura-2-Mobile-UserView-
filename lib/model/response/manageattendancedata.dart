class AttendanceData {
  String? orgid;
  String? interval;
  int? totalEmployee;
  int? totalPresent;
  String? duration;

  AttendanceData({
    this.orgid,
    this.interval,
    this.totalEmployee,
    this.totalPresent,
    this.duration,
  });

  AttendanceData.fromJson(Map<String, dynamic> json) {
    orgid = json['orgid'];
    interval = json['interval'];
    totalEmployee = json['totalemployee'];
    totalPresent = json['totalpresent'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orgid'] = orgid;
    data['interval'] = interval;
    data['totalemployee'] = totalEmployee;
    data['totalpresent'] = totalPresent;
    data['duration'] = duration;
    return data;
  }
}
