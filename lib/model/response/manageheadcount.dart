import 'dart:ui';

class HeadCount {
  String? department;
  int? malecount;
  int? femalecount;
  List<Color>? color;

  HeadCount({
    this.department,
    this.malecount,
    this.femalecount,
    this.color,
  });

  HeadCount.fromJson(Map<String, dynamic> json) {
    department = json['department'] ?? "0";
    malecount = json['malecount'] ?? 0;
    femalecount = json['femalecount'] ?? 0;
    color = [Color(0xFF92B0C6),Color(0xFF9795BD),Color(0xFF536493),Color(0xFFD4BDAC)];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['department'] = department;
    data['malecount'] = malecount;
    data['femalecount'] = femalecount;
    return data;
  }
}
