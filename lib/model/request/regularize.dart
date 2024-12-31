class Regularize {
  String? orgid;
  String? checkin;
  String? checkintime;
  String? checkout;
  String? checkouttime;
  String? comments;

  Regularize(
      {this.orgid,
        this.checkin,
        this.checkintime,
        this.checkout,
        this.checkouttime,
        this.comments});

  Regularize.fromJson(Map<String, dynamic> json) {
    orgid = json['orgid'];
    checkin = json['checkin'];
    checkintime = json['checkintime'];
    checkout = json['checkout'];
    checkouttime = json['checkouttime'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orgid'] = this.orgid;
    data['checkin'] = this.checkin;
    data['checkintime'] = this.checkintime;
    data['checkout'] = this.checkout;
    data['checkouttime'] = this.checkouttime;
    data['comments'] = this.comments;
    return data;
  }
}