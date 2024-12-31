class LeaveDetails {
  final String userId;
  final String orgId;
   var noOfDays;
  var leaveTakenCount;
  var  leaveBalance;

  LeaveDetails({
    required this.userId,
    required this.orgId,
    required this.noOfDays,
    required this.leaveTakenCount,
    required this.leaveBalance,
  });

  // Factory method to create an instance from JSON
  factory LeaveDetails.fromJson(Map<String, dynamic> json) {
    return LeaveDetails(
      userId: json['userid'] as String,
      orgId: json['orgid'] as String,
      noOfDays: json['noofdays'] ,
      leaveTakenCount: json['leavetakencount'] ,
      leaveBalance: json['leavebalance'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'userid': userId,
      'orgid': orgId,
      'noofdays': noOfDays,
      'leavetakencount': leaveTakenCount,
      'leavebalance': leaveBalance,
    };
  }
}
