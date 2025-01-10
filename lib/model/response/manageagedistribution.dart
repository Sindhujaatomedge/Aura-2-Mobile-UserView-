import 'dart:ui';

class AgeDistribution {
  String? orgid;
  String? age_group;
  int? employee_count;
  List<Color>? color;


  AgeDistribution({
    this.orgid,
    this.age_group,
    this.employee_count,
    this.color,

  });

  AgeDistribution.fromJson(Map<String, dynamic> json) {
    orgid = json['orgid'] ?? 0;
    age_group = json['age_group'] ?? '0';
    employee_count = json['employee_count'] ?? 0;
    color = [Color(0xFF92B0C6),Color(0xFF9795BD),Color(0xFF536493),Color(0xFFD4BDAC)];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orgid'] = orgid;
    data['age_group'] = age_group;
    data['employee_count'] = employee_count;

    return data;
  }
}
