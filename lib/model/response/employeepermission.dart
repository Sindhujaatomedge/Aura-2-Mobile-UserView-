class RolePermission {
  String? id;
  String? name;
  String? type;
  Permission? permission;

  RolePermission({this.id, this.name, this.type, this.permission});

  RolePermission.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    permission = json['permission'] != null
        ? new Permission.fromJson(json['permission'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    if (this.permission != null) {
      data['permission'] = this.permission!.toJson();
    }
    return data;
  }
}

class Permission {
  List<int> role;
  List<int> self;
  List<int> team;
  List<int> payrun;
  List<int> holiday;
  List<int> employee;
  List<int> leavetype;
  List<int> department;
  List<int> designation;
  List<int> payapprover;
  List<int> payoverride;
  List<int> leavesetting;
  List<int> organization;
  List<int> payrollconfig;
  List<int> employmenttype;
  List<int> officelocation;
  List<int> salarytemplate;
  List<int> overtimesetting;
  List<int> salarycomponents;
  List<int> attendancesetting;

  Permission(
      {required this.role,
        required this.self,
        required this.team,
        required this.payrun,
        required this.holiday,
        required this.employee,
        required this.leavetype,
        required this.department,
        required this.designation,
        required this.payapprover,
        required this.payoverride,
        required this.leavesetting,
        required this.organization,
        required this.payrollconfig,
        required this.employmenttype,
        required this.officelocation,
        required this.salarytemplate,
        required this.overtimesetting,
        required this.salarycomponents,
        required this.attendancesetting});

  Permission.fromJson(Map<String, dynamic> json)
      : role = (json['role'] as List<dynamic>? ?? []).map((e) => e as int).toList(),
        self = (json['self'] as List<dynamic>? ?? []).map((e) => e as int).toList(),
        team = (json['team'] as List<dynamic>? ?? []).map((e) => e as int).toList(),
        payrun = (json['payrun'] as List<dynamic>? ?? []).map((e) => e as int).toList(),
        holiday = (json['holiday'] as List<dynamic>? ?? []).map((e) => e as int).toList(),
        employee = (json['employee'] as List<dynamic>? ?? []).map((e) => e as int).toList(),
        leavetype = (json['leavetype'] as List<dynamic>? ?? []).map((e) => e as int).toList(),
        department = (json['department'] as List<dynamic>? ?? []).map((e) => e as int).toList(),
        designation = (json['designation'] as List<dynamic>? ?? []).map((e) => e as int).toList(),
        payapprover = (json['payapprover'] as List<dynamic>? ?? []).map((e) => e as int).toList(),
        payoverride = (json['payoverride'] as List<dynamic>? ?? []).map((e) => e as int).toList(),
        leavesetting = (json['leavesetting'] as List<dynamic>? ?? []).map((e) => e as int).toList(),
        organization = (json['organization'] as List<dynamic>? ?? []).map((e) => e as int).toList(),
        payrollconfig = (json['payrollconfig'] as List<dynamic>? ?? []).map((e) => e as int).toList(),
        employmenttype = (json['employmenttype'] as List<dynamic>? ?? []).map((e) => e as int).toList(),
        officelocation = (json['officelocation'] as List<dynamic>? ?? []).map((e) => e as int).toList(),
        salarytemplate = (json['salarytemplate'] as List<dynamic>? ?? []).map((e) => e as int).toList(),
        overtimesetting = (json['overtimesetting'] as List<dynamic>? ?? []).map((e) => e as int).toList(),
        salarycomponents = (json['salarycomponents'] as List<dynamic>? ?? []).map((e) => e as int).toList(),
        attendancesetting = (json['attendancesetting'] as List<dynamic>? ?? []).map((e) => e as int).toList();


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    data['self'] = this.self;
    data['team'] = this.team;
    data['payrun'] = this.payrun;
    data['holiday'] = this.holiday;
    data['employee'] = this.employee;
    data['leavetype'] = this.leavetype;
    data['department'] = this.department;
    data['designation'] = this.designation;
    data['payapprover'] = this.payapprover;
    data['payoverride'] = this.payoverride;
    data['leavesetting'] = this.leavesetting;
    data['organization'] = this.organization;
    data['payrollconfig'] = this.payrollconfig;
    data['employmenttype'] = this.employmenttype;
    data['officelocation'] = this.officelocation;
    data['salarytemplate'] = this.salarytemplate;
    data['overtimesetting'] = this.overtimesetting;
    data['salarycomponents'] = this.salarycomponents;
    data['attendancesetting'] = this.attendancesetting;
    return data;
  }
}