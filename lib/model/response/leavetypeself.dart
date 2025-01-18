class LeaveData {
  String leavetypename;
  double leavetaken;
  double allottedleaves;
  double availableleaves;
  double leavetakenpercentage;
  double availableleavepercentage;
  double allottedleavepercentage;

  LeaveData({
    required this.leavetypename,
    required this.leavetaken,
    required this.allottedleaves,
    required this.availableleaves,
    required this.leavetakenpercentage,
    required this.availableleavepercentage,
    required this.allottedleavepercentage,
  });

  // Factory constructor to parse from JSON
  factory LeaveData.fromJson(Map<String, dynamic> json) {
    return LeaveData(
      leavetypename: json['leavetypename'],
      leavetaken: double.parse(json['leavetaken']),
      allottedleaves: double.parse(json['allottedleaves']),
      availableleaves: double.parse(json['availableleaves']),
      leavetakenpercentage: double.parse(json['leavetakenpercentage']),
      availableleavepercentage: double.parse(json['availableleavepercentage']),
      allottedleavepercentage: double.parse(json['allottedleavepercentage']),
    );
  }

  // Convert back to JSON
  Map<String, dynamic> toJson() {
    return {
      'leavetypename': leavetypename,
      'leavetaken': leavetaken.toString(),
      'allottedleaves': allottedleaves.toString(),
      'availableleaves': availableleaves.toString(),
      'leavetakenpercentage': leavetakenpercentage.toString(),
      'availableleavepercentage': availableleavepercentage.toString(),
      'allottedleavepercentage': allottedleavepercentage.toString(),
    };
  }
}
