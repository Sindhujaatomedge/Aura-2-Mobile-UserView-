import 'dart:ui';

class EmployeeTenure {
  String? years_of_service;
  int? male_count;
  int? female_count;

  List<Color>? color;

  EmployeeTenure({
    this.years_of_service,
    this.male_count,
    this.female_count,

    this.color,
  });

  EmployeeTenure.fromJson(Map<String, dynamic> json) {
    years_of_service = json['years_of_service'];
    female_count = json['female_count'];
    male_count = json['male_count'];
    color = [Color(0xFF92B0C6),Color(0xFF9795BD),Color(0xFF536493),Color(0xFFD4BDAC)];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['years_of_service'] = years_of_service;
    data['male_count'] = male_count;
    data['female_count'] = female_count;
    return data;
  }
}
