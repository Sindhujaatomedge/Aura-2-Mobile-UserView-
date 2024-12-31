class Attendancelog {
  final String id;
  final String name;
  final String userid;
  final String checkin;
  final String checkintime;
  final String checkinmedium;
  final String checkout;
 final String checkouttime;
  final String checkoutmedium;
  final String hours;
  final String? comments;
  final String status;

  Attendancelog(
      {
        required this.id,
        required this.name,
        required this.userid,
        required this.checkin,
        required this.checkintime,
        required this.checkinmedium,
        required this.checkout,
        required this.checkouttime,
        required this.checkoutmedium,
        required this.hours,
        required this.comments,
        required this.status});

  factory Attendancelog.fromJson(Map<String, dynamic> json) {
    return Attendancelog(
      id: json['id'] ?? '',
      name :json['name'] ?? '',
      userid: json['userid'] ?? '',
      checkin: json['checkin'] ?? '',

      checkinmedium: json['checkinmedium'] ?? '',
      checkout: json['checkout'] ?? '',

      checkintime: json['checkintime'] ?? '',
      checkouttime: json['checkouttime'] ?? '',
      checkoutmedium: json['checkoutmedium'] ?? '',
      hours: json['hours'] ?? '',
      comments: json['comments'] ?? '',
      status: json['status'] ?? '',

    );
  }
}