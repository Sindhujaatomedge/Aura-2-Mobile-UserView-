

class LeaveRequestModel {
  String? orgid;
  String? leave_type_id;
  String? start_date;
  String? end_date;
  String? reason;
  String? leave_duration;
  String? no_of_days;
  String? status;
  String? behalf;
  LeaveRequestModel({this.orgid,this.leave_type_id, this.start_date, this.end_date, this.reason,this.leave_duration, this.no_of_days,this.status,this.behalf});


  Map<String, dynamic> toJson() {
    return {
      'orgid': this.orgid,
      'leave_type_id':this.leave_type_id,
      'start_date': this.start_date,
      'end_date': this.end_date,
      'reason':this.reason,
      'leave_duration': this.leave_duration,
      'no_of_days': this.no_of_days,
      'status': this.status,
      'behalf':this.behalf

    };
  }



}
