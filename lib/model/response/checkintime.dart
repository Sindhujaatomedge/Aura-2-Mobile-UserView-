import 'package:intl/intl.dart'; // Import the intl package

class AttendanceCheckin {
  String orgId;
  int hours;
  int mins;
  int sec;
  bool isCheckoutPending;
  DateTime checkin;
  String checkout;
  bool checkoutValid;
  String checkoutTime;
  bool checkoutTimeValid;

  AttendanceCheckin({
    required this.orgId,
    required this.hours,
    required this.mins,
    required this.sec,
    required this.isCheckoutPending,
    required this.checkin,
    required this.checkout,
    required this.checkoutValid,
    required this.checkoutTime,
    required this.checkoutTimeValid,
  });

  factory AttendanceCheckin.fromJson(Map<String, dynamic> json) {
    // Define a custom date format that can handle 'IST' timezone
    final DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss z");

    return AttendanceCheckin(
      orgId: json['orgid'] ?? '',
      hours: json['hours'] ?? '',
      mins: json['mins'] ?? '',
      sec: json['sec'] ?? '',
      isCheckoutPending: json['ischeckoutpending'] ??'',
      // Parse the checkin date using the custom format
      checkin: format.parse(json['checkin'] ?? ''),
      checkout: json['checkout']['String'] ?? '',
      checkoutValid: json['checkout']['Valid'] ?? '',
      checkoutTime: json['checkouttime']['String'] ?? '',
      checkoutTimeValid: json['checkouttime']['Valid'] ?? '',
    );
  }
}
