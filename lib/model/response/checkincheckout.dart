class Checkincheheckoutmedium {
  final String checkinmedium;
  final String checkintime;
  final String checkouttime;

  Checkincheheckoutmedium({
    required this.checkinmedium,
    required this.checkintime,
    required this.checkouttime,
  });

  factory Checkincheheckoutmedium.fromJson(Map<String, dynamic> json) {
    return Checkincheheckoutmedium(
      checkinmedium: json['checkinmedium'] ?? '',
      checkintime: json['checkintime'] ?? '',
      checkouttime: json['checkouttime'] ?? '',
    );
  }
}
