import 'dart:ui';

class EmployeeTurnover {
  var totalempleavingthisyear;
  var percentage;


  EmployeeTurnover({
    this.totalempleavingthisyear,
    this.percentage,

  });

  EmployeeTurnover.fromJson(Map<String, dynamic> json) {
    totalempleavingthisyear = json['totalempleavingthisyear'] ?? "0";
    percentage = json['percentage'] ?? 0;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalempleavingthisyear'] = totalempleavingthisyear;
    data['percentage'] = percentage;

    return data;
  }
}
