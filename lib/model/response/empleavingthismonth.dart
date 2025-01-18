import 'dart:ui';

class Empleavingthismonth {
  var count;
  var percentage;


  Empleavingthismonth({
    this.count,
    this.percentage,

  });

  Empleavingthismonth.fromJson(Map<String, dynamic> json) {
    count = json['count'] ?? "0";
    percentage = json['percentage'] ?? 0;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['percentage'] = percentage;

    return data;
  }
}
