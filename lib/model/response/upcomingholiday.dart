class UpcomingHoliday {
  final String id;
  final String name;
  final String fromdate;
  final bool mandatory;
  final String attachment;

  UpcomingHoliday({
    required this.id,
    required this.name,
    required this.fromdate,
    required this.mandatory,
    required this.attachment,
  });

  // Factory method to create an instance from JSON
  factory UpcomingHoliday.fromJson(Map<String, dynamic> json) {
    return UpcomingHoliday(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      fromdate: json['fromdate'] ?? '',
      mandatory: json['mandatory'] == 'true',
      attachment: json['attachment'] ?? '',
    );
  }

  // Override toString to display object details
  @override
  String toString() {
    return 'UpcomingHoliday(id: $id, name: $name, fromdate: $fromdate, mandatory: $mandatory, attachment: $attachment)';
  }
}
