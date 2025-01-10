import 'dart:ui';

class Presenttodaycount {
  var totalpresentcount;
 var percentage;


  Presenttodaycount({
    this.totalpresentcount,
    this.percentage,

  });

  Presenttodaycount.fromJson(Map<String, dynamic> json) {
    totalpresentcount = json['totalpresentcount'] ?? "0";
    percentage = json['percentage'] ?? 0;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalpresentcount'] = totalpresentcount;
    data['percentage'] = percentage;

    return data;
  }
}
