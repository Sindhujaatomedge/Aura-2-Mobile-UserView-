class EmployeeSatisfaction {
  String? orgid;
  String? emotion;
  double? percentage; // Must be between 0.0 and 1.0
  String? count;

  EmployeeSatisfaction({
    this.orgid,
    this.emotion,
    this.percentage,
    this.count,
  });

  EmployeeSatisfaction.fromJson(Map<String, dynamic> json) {
    orgid = json['orgid'];
    emotion = json['emotion'];
    // Convert percentage to a fraction between 0.0 and 1.0
    if (json['percentage'] is int) {
      percentage = (json['percentage'] as int).toDouble() / 100; // Convert int and divide by 100
    } else if (json['percentage'] is double) {
      percentage = json['percentage'] / 100; // Divide double by 100
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orgid'] = orgid;
    data['emotion'] = emotion;
    // Convert fraction back to percentage for JSON
    data['percentage'] = percentage != null ? percentage! * 10 : null;
    data['count'] = count;
    return data;
  }
}
