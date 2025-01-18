class Member {
  String? userid;
  String? employeeid;
  String? firstname;
  String? lastname;
  String? emailaddress;
  String? role;
  String? department;
  String? designation;
  String? location;
  String? dateofjoining;
  String? status;
  String? reportingmanager;
  String? employmenttype;
  String? genderid;
  String? team;
  String? dateofexit;

  Member({this.userid,
    this.employeeid,
    this.firstname,
    this.lastname,
    this.emailaddress,
    this.role,
    this.department,
    this.designation,
    this.location,
    this.dateofjoining,
    this.status,
    this.reportingmanager,
    this.employmenttype,
    this.genderid,
    this.team,
    this.dateofexit});

  Member.fromJson(Map<String, dynamic> json) {
    userid = json['userid'] ?? '';
    employeeid = json['employeeid'] ?? '';
    firstname = json['firstname'] ?? '';
    lastname = json['lastname'] ?? '';
    emailaddress = json['emailaddress'] ?? '';
    role = json['role'] ?? '';
    department = json['department'] ?? '';
    designation = json['designation']?? '';
    location = json['location'] ?? '';
    dateofjoining = json['dateofjoining'] ?? '';
    status = json['status'];
    reportingmanager = json['reportingmanager']?? '';
    employmenttype = json['employmenttype'] ?? '';
    genderid = json['genderid'] ?? '';
    team = json['team'] ?? '';
    dateofexit = json['dateofexit'] ?? '';
  }
}