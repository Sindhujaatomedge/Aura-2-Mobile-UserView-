class PersonalDetails {
  String? userid;
  String? firstname;
  String? lastname;
  String? dateofbirth;
  int? age;
  String? gender;
  String? maritalstatus;
  String? avatar;

  PersonalDetails(
      {this.userid,
        this.firstname,
        this.lastname,
        this.dateofbirth,
        this.age,
        this.gender,
        this.maritalstatus,
        this.avatar});

  PersonalDetails.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    dateofbirth = json['dateofbirth'];
    age = json['age'];
    gender = json['gender'];
    maritalstatus = json['maritalstatus'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['dateofbirth'] = this.dateofbirth;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['maritalstatus'] = this.maritalstatus;
    data['avatar'] = this.avatar;
    return data;
  }
}