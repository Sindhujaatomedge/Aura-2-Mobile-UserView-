import 'dart:ui';

class LeaveReport {
  String? leavetypename;
  String? absentemployeecount_by_leavetype;

  int? total_absent_employee_count;
  List<Color>? color;

  LeaveReport({
    this.leavetypename,
    this.absentemployeecount_by_leavetype,
    this.total_absent_employee_count,
    this.color,
  });

  LeaveReport.fromJson(Map<String, dynamic> json) {
    leavetypename = json['leavetypename'];
    absentemployeecount_by_leavetype = json['absentemployeecount_by_leavetype'];
    total_absent_employee_count = json['total_absent_employee_count'];
    color = [Color(0xFF92B0C6),Color(0xFF9795BD),Color(0xFF536493),Color(0xFFD4BDAC)];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['leavetypename'] = leavetypename;
    data['absentemployeecount_by_leavetype'] = absentemployeecount_by_leavetype;

    data['total_absent_employee_count'] = total_absent_employee_count;
    return data;
  }
}
