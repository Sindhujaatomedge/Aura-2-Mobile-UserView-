import 'dart:ui';

class FeedBacktotal {
  var totalfeedbackcount;
  var totalfeedbackpercentage;


  FeedBacktotal({
    this.totalfeedbackcount,
    this.totalfeedbackpercentage,

  });

  FeedBacktotal.fromJson(Map<String, dynamic> json) {
    totalfeedbackcount = json['totalfeedbackcount'] ?? "0";
    totalfeedbackpercentage = json['totalfeedbackpercentage'] ?? 0;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalfeedbackcount'] = totalfeedbackcount;
    data['totalfeedbackpercentage'] = totalfeedbackpercentage;

    return data;
  }
}
